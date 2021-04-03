Gem::Specification.new do |s|
  s.name          = 'fa_rails'
  s.version       = '0.1.25'
  s.date          = '2021-04-03'
  s.summary       = 'FontAwesome helper for Rails'
  s.description   = 'A helper module for using FontAwesome icons in Rails.'
  s.homepage      = 'http://rubygems.org/gems/fa_rails'
  s.license       = 'GPL-3.0'
  s.authors       = ['Julian Fiander']
  s.email         = 'julian@fiander.one'
  s.require_paths = %w[lib spec doc]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '~> 2.4'

  s.add_development_dependency 'rake',      '~> 12.2', '>= 12.2.1'
  s.add_development_dependency 'rspec',     '~> 3.7',  '>= 3.7.0'
  s.add_development_dependency 'simplecov', '~> 0.15', '>= 0.15.1'
end
