require "bundler"

Gem::Specification.new do |s|
  s.name              = "rack-client"
  s.version           = "0.2.2.pre"
  s.author            = "Tim Carey-Smith"
  s.email             = "tim@spork.in"
  s.homepage          = "http://github.com/halorgium/rack-client"
  s.summary           = "A client wrapper around a Rack app or HTTP"
  s.description       = s.summary
  s.files             = %w[
.gitignore
Gemfile
History.txt
LICENSE
README.textile
Rakefile
demo/client.rb
demo/config.ru
demo/demo.rb
demo/demo_spec.rb
lib/rack/client.rb
lib/rack/client/auth.rb
lib/rack/client/follow_redirects.rb
lib/rack/client/http.rb
spec/apps/example.org.ru
spec/auth_spec.rb
spec/core_spec.rb
spec/endpoint_spec.rb
spec/https_spec.rb
spec/middleware_spec.rb
spec/quality_spec.rb
spec/redirect_spec.rb
spec/spec_helper.rb
]

  Bundler::Dsl.load_gemfile("Gemfile").dependencies.
    select { |d| d.only && d.only.include?("release") }.
    each   { |d| s.add_dependency(d.name, d.version)  }
end
