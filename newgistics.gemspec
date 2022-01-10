# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "newgistics/version"

Gem::Specification.new do |spec|
  spec.name          = "newgistics"
  spec.version       = Newgistics::VERSION
  spec.authors       = ["Manuel Martinez", "James Russo"]
  spec.email         = ["manuel@kubecommerce.com", "james.russo@rocketsofawesome.com"]

  spec.summary       = "Ruby API client for Newgistics"
  spec.description   = "Ruby API client for Newgistics"
  spec.homepage      = "https://github.com/rocketsofawesome/newgistics-ruby/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "virtus", "~> 1.0"
  spec.add_dependency "nokogiri", "~> 1.8"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "tzinfo", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov", "~> 0.17.1"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "vcr", "~> 3.0.3"
  spec.add_development_dependency "timecop", "~> 0.9"
end
