# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rscmd/version'

Gem::Specification.new do |spec|
  spec.name          = "rscmd"
  spec.version       = Rscmd::VERSION
  spec.authors       = ["Prasad V"]
  spec.email         = ["prasad@rightsolutions.io"]

  spec.summary       = %q{the bunch of scripts used at rs}
  spec.description   = %q{rscmd is a set of scripts used for jekyll based webdevelopment with aws}
  spec.homepage      = "http://rightsolutions.io"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'httparty'
  spec.add_dependency 'octokit'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'json'
  spec.add_dependency 'colorize'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

end
