# -*- encoding: utf-8 -*-

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pundit_pure/version"

Gem::Specification.new do |gem|
  gem.name          = "pundit_pure"
  gem.version       = PunditPure::VERSION
  gem.authors       = ["Jonas Nicklas", "Elabs AB", "Fran Worley"]
  gem.email         = ["jonas.nicklas@gmail.com", "dev@elabs.se", "fran.em.worley@googlemail.com"]
  gem.description   = "Object oriented authorization for POR applications"
  gem.summary       = "OO authorization for Ruby"
  gem.homepage      = "https://github.com/fran-worley/pundit_pure"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rack"
end
