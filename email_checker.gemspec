# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_checker/version'

Gem::Specification.new do |spec|
  spec.name          = 'email_checker'
  spec.version       = EmailChecker::VERSION
  spec.authors       = ['Genaro Madrid']
  spec.email         = ['genmadrid@gmail.com']
  spec.summary       = %q{Check if an email address is can receive E-mails.}
  spec.description   = %q{Validates, at some degree, that the email you want to send to it's valid and exists.}
  spec.homepage      = 'https://github.com/genaromadrid/email_checker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.7'
  spec.add_development_dependency 'pry', '~> 0.10', '>= 0.10.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.3', '>= 3.3.0'
  spec.add_development_dependency 'bump', '~> 0.5', '>= 0.5.3'
end
