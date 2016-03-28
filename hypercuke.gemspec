# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hypercuke/version'

Gem::Specification.new do |spec|
  spec.name          = "hypercuke"
  spec.version       = Hypercuke::VERSION
  spec.authors       = ["Sam Livingston-Gray"]
  spec.email         = ["sam.livingstongray@livingsocial.com"]
  spec.summary       = %q{Run Cucumber scenarios at multiple layers of your application.}
  spec.description   = %q{Hypercuke helps you use Cucumber to do BDD at multiple layers of your application, and gently nudges you into writing your scenarios in high-level terms that your users can understand.}
  spec.homepage      = "https://github.com/livingsocial/hypercuke"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "cucumber", "~> 1.3"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.4.0"

  spec.add_development_dependency 'geminabox' # TODO: remove this when publishing
end
