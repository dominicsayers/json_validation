# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_validation/version'

Gem::Specification.new do |spec|
  spec.name          = "json_validation"
  spec.version       = JsonValidation::VERSION
  spec.authors       = ["Peter Inglesby"]
  spec.email         = ["peter.inglesby@gmail.com"]

  spec.summary       = "JsonValidation validates JSON according to a JSON Schema."
  spec.homepage      = "http://github.com/inglesp/json_validation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "addressable"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.0"
end
