module CurrencyConverter
  class Exchange
    def convert(from, to)
      rate = Rates(from.currency, to)
      raise InvalidCurrency, "Unknown ratio: #{from.currency}/#{to}" unless rate
      from.amount * rate
    end
  end
end
