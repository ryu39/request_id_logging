# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_id_logging/version'

Gem::Specification.new do |spec|
  spec.name          = 'request_id_logging'
  spec.version       = RequestIdLogging::VERSION
  spec.authors       = ['ryu39']
  spec.email         = ['dev.ryu39@gmail.com']

  spec.summary       = %q{Logging with request id in your Rails app.}
  spec.description   = <<EOS.gsub("\n", ' ')
This gems provide a Rack middleware and a logger formatter for logging with request id in your Rails app.
EOS
  spec.homepage      = 'https://github.com/ryu39/request_id_logging'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
