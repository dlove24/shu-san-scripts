# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "shu-san-scripts"
  gem.homepage = "http://github.com/dlove24/shu-san-scripts"
  gem.license = "ISC"
  gem.summary = %Q{Scripts used to set-up and manage iSCSI targets on OpenSolaris (ZFS) systems.}
  gem.description = %Q{See the README file.}
  gem.email = "david@homeunix.org.uk"
  gem.authors = ["David Love"]
  gem.files = Dir.glob('bin/*.rb')
  gem.files << Dir.glob('lib/**/*.rb')
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "shu-san-scripts #{version}"
  rdoc.rdoc_files.include('README*')
  # rdoc.rdoc_files.include('lib/**/*.rb')
end
