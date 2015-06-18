module CurrencyConverter
  class Rates
    def self.index(base_currency, target_currency)
      base_currency.upcase!
      target_currency.upcase!
      # free plan on currencylayer allows only USD as the base currency
      if target_currency == 'USD'
        rate = BigDecimal(1) / self.index(target_currency, base_currency)
      else
        rate = get_rate(base_currency, target_currency)
      end
      rate.round(6)
    end

    def self.get_rate(base_currency, target_currency)
      BigDecimal(RatesFetcher.response_json['quotes']["#{base_currency}#{target_currency}"].to_s)
    end
  end
end

class Object
  def Rates(base_currency, target_currency)
    CurrencyConverter::Rates.index(base_currency, target_currency)
  end
end
