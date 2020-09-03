require_relative "lib/bunter/version"

Gem::Specification.new do |spec|
  spec.name          = "bunter"
  spec.version       = Bunter::VERSION
  spec.authors       = ["Z. Grace Moreau"]
  spec.email         = ["zgracem@users.noreply.github.com"]

  spec.summary       = "A simple snippets manager for Alfred.app."
  spec.homepage      = "https://github.com/zgracem/bunter"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir["**/*.rb"]
  spec.bindir        = "bin"
  spec.executables   = ["bunter"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "yard" # <github.com/lsegal/yard/>

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "plist" # <github.com/patsplat/plist>
  spec.add_runtime_dependency "rubyzip" # <github.com/rubyzip/rubyzip>
  spec.add_runtime_dependency "symbolized" # <github.com/TamerShlash/symbolized>
end
