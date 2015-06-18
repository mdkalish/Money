require 'dotenv'
Dotenv.load
require 'currency_converter/exceptions/invalid_currency'
require 'currency_converter/rates_fetcher'
require 'currency_converter/exchange'
require 'currency_converter/rates'
require 'currency_converter/money'
require 'bigdecimal'
require 'bigdecimal/util'
require 'open-uri'
require 'json'
