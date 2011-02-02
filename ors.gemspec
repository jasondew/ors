# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ors/version"

Gem::Specification.new do |s|
  s.name        = "ors"
  s.version     = ORS::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Dew and John Long"]
  s.email       = ["jason.dew@ors.sc.gov and john.long@ors.sc.gov"]
  s.homepage    = ""
  s.summary     = %q{Heroku-like deployment utilities for ORS}
  s.description = %q{Heroku-like deployment utilities for ORS}

  s.rubyforge_project = "ors"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "git"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rr"
end
