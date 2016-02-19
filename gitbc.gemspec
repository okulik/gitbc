# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gitbc/version"

Gem::Specification.new do |spec|
  spec.name          = 'gitbc'
  spec.version       = Gitbc::VERSION
  spec.authors       = ['Orest Kulik']
  spec.email         = 'orest@nisdom.com'

  spec.summary       = 'GitHub Basecamp to-dos extractor'
  spec.description   = "Extracts Basecamp to-do URLs and titles from GitHub pull requests body"
  spec.platform      = Gem::Platform::RUBY
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'octokit', '~> 4.2'
  spec.add_dependency 'colorize', '~> 0.7'
  spec.add_dependency 'httparty', '~> 0.13.7'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
