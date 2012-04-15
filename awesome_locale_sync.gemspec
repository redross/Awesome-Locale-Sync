# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "awesome_locale_sync/version"

Gem::Specification.new do |s|
  s.name        = "awesome_locale_sync"
  s.version     = AwesomeLocaleSync::VERSION
  s.authors     = ["Gintaras Sakalauskas"]
  s.email       = ["gintaras.sakalauskas@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Small utility to sync multiple translation files (YAML)}
  s.description = %q{A better way to sync yaml files then sending it trough email. Hopefully.}

  s.rubyforge_project = "awesome_locale_sync"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "ya2yaml"
end
