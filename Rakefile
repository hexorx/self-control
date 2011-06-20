require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "self-control"
    gem.summary = %Q{Self-Control builds on you existing state machine to create full work flows.}
    gem.description = %Q{State machines are awesome but sometimes you need a little more. Like who should do what in order for it to move on? How many steps are left? How can I restfully trigger the next event? Self Control adds route helpers, controller actions and a dsl to turn your existing state machines into full workflows. It is designed to use rails 3 with ActiveModel and should work with any state machine with just a few extra methods.}
    gem.email = "hexorx@gmail.com"
    gem.homepage = "http://github.com/hexorx/self-control"
    gem.authors = ["hexorx"]
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "yard"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
