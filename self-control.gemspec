# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{self-control}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["hexorx"]
  s.date = %q{2011-06-20}
  s.description = %q{State machines are awesome but sometimes you need a little more. Like who should do what in order for it to move on? How many steps are left? How can I restfully trigger the next event? Self Control adds route helpers, controller actions and a dsl to turn your existing state machines into full workflows. It is designed to use rails 3 with ActiveModel and should work with any state machine with just a few extra methods.}
  s.email = %q{hexorx@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/self-control.rb",
    "lib/self-control/controller_additions.rb",
    "lib/self-control/exceptions.rb",
    "lib/self-control/flow.rb",
    "lib/self-control/flow_builder.rb",
    "lib/self-control/railtie.rb",
    "lib/self-control/route_helpers.rb",
    "lib/self-control/step.rb",
    "lib/self-control/step_adapter.rb",
    "lib/self-control/step_builder.rb",
    "self-control.gemspec",
    "spec/self-control_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/hexorx/self-control}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Self-Control builds on you existing state machine to create full work flows.}
  s.test_files = [
    "spec/self-control_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end

