# frozen_string_literal: true

require_relative 'lib/weatherb/version'

Gem::Specification.new do |spec|
  spec.name          = 'weatherb'
  spec.version       = Weatherb::VERSION
  spec.authors       = ['Zackky Muhammad']
  spec.email         = ['m.zackky@gmail.com']

  spec.summary       = 'A simple Ruby gem that can tell you all about the weather, superb!'
  spec.description   = 'Weatherb comes from weather + rb (ruby file extension).' \
                       " It's basically a Ruby gem for retrieving data about weather" \
                       ' using the ClimaCell API in a simple way.'
  spec.homepage      = 'https://github.com/zackijack/weatherb'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/zackijack/weatherb'
  spec.metadata['changelog_uri'] = "https://github.com/zackijack/weatherb/releases/tag/v#{spec.version}"

  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
end
