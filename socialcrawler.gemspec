# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socialcrawler/version'

Gem::Specification.new do |spec|
  spec.name          = "socialcrawler"
  spec.version       = SocialCrawler::VERSION
  spec.authors       = ["Ivica Ceraj"]
  spec.email         = ["iceraj@gmail.com"]
  spec.summary       = %q{SocialCrawler looks for social media links for different sites}
  spec.description   = %q{It read file containing list of urls and produces output file with domain, page title, twitter, facebook and google plus handles found on the page}
  spec.homepage      = "http://github.com/iceraj/socialcrawler"
  spec.license       = "LGPL 2.1"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "semantic", "~> 1.0"
  spec.add_development_dependency "simplecov", "~> 0.9"
  spec.add_development_dependency "simplecov-html", "~> 0.8"


end
