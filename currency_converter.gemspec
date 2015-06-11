lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'currency_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "currency_converter"
  spec.version       = CurrencyConverter::VERSION
  spec.authors       = ["mdkalish"]
  spec.email         = ["mdkalish4git@gmail.com"]

  spec.summary       = %q{Quickly convert currencies in CLI.}
  spec.description   = %q{Convert most popular currencies by actual rates.}
  spec.homepage      = "https://github.com/mdkalish/Money"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', "~> 3.2"
  spec.add_development_dependency "pry", "~> 0.10"
end

