$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'currency_converter'
include CurrencyConverter

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc' # if config.files_to_run.one?
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  # config.profile_examples = 10
  # config.order = :random
  # Kernel.srand config.seed
end
