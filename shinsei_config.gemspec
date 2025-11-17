# frozen_string_literal: true

require_relative 'lib/shinsei_config/version'

Gem::Specification.new do |spec|
  spec.name = 'shinsei_config'
  spec.version = ShinseiConfig::VERSION
  spec.authors = ['Denis Talakevich']
  spec.email = ['senid231@gmail.com']

  spec.summary = 'Loads and validates configuration from YAML files with schema validation'
  spec.description = 'ShinseiConfig (真正 — genuine, correct, authentic) loads configuration from YAML files, ' \
                     'supports ERB interpolation, per-environment splitting, and validates structure using dry-schema.'
  spec.homepage = 'https://github.com/senid231/shinsei_config'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/senid231/shinsei_config'
  spec.metadata['changelog_uri'] = 'https://github.com/senid231/shinsei_config/blob/master/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'dry-schema', '~> 1.13'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
