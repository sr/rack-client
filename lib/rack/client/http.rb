require 'net/http'

class Rack::Client::HTTP
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
      get = Net::HTTP::Get.new(request.path, request_headers)
      http.request(get) do |response|
        return parse(response)
      end
    when "POST"
      post = Net::HTTP::Post.new(request.path, request_headers)
      post.body = @env["rack.input"].read
      http.request(post) do |response|
        return parse(response)
      end
    when "PUT"
      put = Net::HTTP::Put.new(request.path, request_headers)
      put.body = @env["rack.input"].read
      http.request(put) do |response|
        return parse(response)
      end
    when "DELETE"
      delete = Net::HTTP::Delete.new(request.path, request_headers)
      http.request(delete) do |response|
        return parse(response)
      end
    else
      raise "Unsupported method: #{request.request_method.inspect}"
    end
  end

  def http
    Net::HTTP.new(request.host, request.port)
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

  def request
    @request ||= Rack::Request.new(@env)
  end

  def request_headers
    headers = {}
    @env.each do |k,v|
      if v && k =~ /^HTTP_(.*)$/
        headers[$1] = v
      end
    end
    headers
  end
end
