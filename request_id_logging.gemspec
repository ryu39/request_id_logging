lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_id_logging/version'

Gem::Specification.new do |spec|
  spec.name          = 'request_id_logging'
  spec.version       = RequestIdLogging::VERSION
  spec.authors       = ['ryu39']
  spec.email         = ['dev.ryu39@gmail.com']

  spec.summary       = 'Logging with request id in your Rails app.'
  spec.description   = 'This gems provide a Rack middleware and a logger formatter ' \
                       'for logging with request id in your Rails app.'
  spec.homepage      = 'https://github.com/ryu39/request_id_logging'
  spec.license       = 'MIT'

  spec.files         = %w(LICENSE.txt) + Dir['lib/**/*.rb']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'ryu39cop', '~> 0.49.1.0'
end
