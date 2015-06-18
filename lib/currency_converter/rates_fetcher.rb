module CurrencyConverter
  class RatesFetcher
    ACCESS_KEY = ENV['currencylayer_api_access_key']
    BASE_URL = "http://apilayer.net/api/live?access_key=#{ACCESS_KEY}"
    KNOWN_CURRENCIES = ["usd", "eur", "gbp", "chf", "jpy", "pln"]
    QUERY = "&currencies=#{KNOWN_CURRENCIES.join(',')}"

    def self.response_json
      @response ||= parse_response
    end

    def self.parse_response
      JSON.parse(response.read)
    end

    def self.response
      open("#{BASE_URL}#{QUERY}")
    end
  end
end
