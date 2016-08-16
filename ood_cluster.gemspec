# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ood_cluster/version'

Gem::Specification.new do |spec|
  spec.name          = "ood_cluster"
  spec.version       = OodCluster::VERSION
  spec.authors       = ["Jeremy Nicklas"]
  spec.email         = ["jnicklas@osc.edu"]
  spec.summary       = %q{Used to describe an HPC center cluster.}
  spec.description   = %q{Used to describe an HPC center cluster and its resources.}
  spec.homepage      = "https://github.com/OSC/ood_cluster"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.2.0"

  spec.add_dependency "pbs", "~> 2.0", ">= 2.0.1"
  spec.add_dependency "addressable", "~> 2.4"
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
