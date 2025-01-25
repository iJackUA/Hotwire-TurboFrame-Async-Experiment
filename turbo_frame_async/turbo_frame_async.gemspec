# frozen_string_literal: true

require_relative "lib/turbo_frame_async/version"

Gem::Specification.new do |spec|
  spec.name = "turbo_frame_async"
  spec.version = TurboFrameAsync::VERSION
  spec.authors = ["Your Name"]
  spec.email = ["your.email@example.com"]

  spec.summary = "Async loading capability for Turbo Frames"
  spec.description = "Provides async loading capability for Turbo Frames with loading/success/failure states"
  spec.homepage = "https://github.com/yourusername/turbo_frame_async"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  # Prevent pushing this gem to RubyGems.org during development
  spec.metadata["allowed_push_host"] = "none"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # Remove changelog_uri for now since we don't have one yet
  # spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir[
    "lib/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md"
  ]

  spec.add_dependency "concurrent-ruby"
  spec.add_dependency "concurrent-ruby-edge"
  spec.add_dependency "rails", ">= 6.1.0"
  spec.add_dependency "turbo-rails"
end
