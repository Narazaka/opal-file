# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "opal-file/version"

Gem::Specification.new do |spec|
  spec.name          = "opal-file"
  spec.version       = OpalFile::VERSION
  spec.authors       = ["Narazaka"]
  spec.email         = ["info@narazaka.net"]

  spec.summary       = "native File.read, File.write etc... for Opal"
  spec.homepage      = "https://github.com/Narazaka/opal-file"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "opal"
end
