require "typhoeus"
require 'net/http'

class Rack::Client::Typhoeus
  def self.call(env)
    new(env).run
  end

  def initialize(env)
    @env = env
  end

  def run
    case request.request_method
    when "HEAD"
      head = Net::HTTP::Head.new(request.path, request_headers)
      http.request(head) do |response|
        return parse(response)
      end
    when "GET"
      _parse Typhoeus::Request.get(url, :headers => request_headers)
    when "POST"
      _parse Typhoeus::Request.post(url, :headers => request_headers,
        :body => @env["rack.input"].read
      )
    when "PUT"
      _parse Typhoeus::Request.put(url, :headers => request_headers,
        :body => @env["rack.input"].read
      )
    when "DELETE"
      _parse Typhoeus::Request.delete(url, :headers => request_headers)
    else
      raise "Unsupported method: #{request.request_method.inspect}"
    end
  end

  def http
    Net::HTTP.new(request.host, request.port)
  end

  def url
    @url ||= "http://#{request.host}:#{request.port}#{request.path}"
  end

  def parse(response)
    status = response.code.to_i
    headers = {}
    response.each do |key,value|
      key = key.gsub(/(\w+)/) do |matches|
        matches.sub(/^./) do |char|
          char.upcase
        end
      end
      headers[key] = value
    end
    [status, headers, response.body.to_s]
  end

  def _parse(response)
    status = response.code.to_i
    headers = response.headers.split("\r\n").
      reject { |l| l.include?("HTTP") }.
      inject({}) { |h, l|
        parts = l.split(": ")
        h.update(parts.first => parts.last)
      }
    [status, headers, response.body.to_s]
  end

  def request
    @request ||= Rack::Request.new(@env)
  end

  def request_headers
    headers = {}
    @env.each do |k,v|
      if k =~ /^HTTP_(.*)$/
        headers[$1] = v
      end
    end
    headers
  end
end
