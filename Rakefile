require 'rake'
require "rake/clean"
require "spec/rake/spectask"

require "lib/rack/client"

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.spec_opts = ['-c']
end

task :default  => :spec

directory "pkg/"
CLOBBER.include "pkg"

GEM = "pkg/rack-client-#{Rack::Client::VERSION}.gem"

desc "Build the gem"
file GEM => "pkg/" do |f|
  sh "gem exec gem build rack-client.gemspec"
  mv File.basename(f.name), f.name
end

desc "Install the gem"
task :install => GEM do
  sh "gem install --no-rdoc --no-ri --local #{GEM}"
end
