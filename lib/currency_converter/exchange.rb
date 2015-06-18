module CurrencyConverter
  class Exchange
    def convert(from, to)
      @args = [from.currency.downcase, to.downcase]
      if !currencies_known?
        raise InvalidCurrency, "Unknown ratio: #{from.currency.upcase}/#{to.upcase}"
      elsif @args.uniq.count == 1
        from.amount
      elsif !direct_usd_conversion?
        rate = Rates('usd', @args[1]) / Rates('usd', @args[0])
        (from.amount * rate).round(2) # notify it's an approximation
      else
        from.amount * Rates(from.currency, to) #{to.upcase}" # notify about its precision
      end
    end

    def currencies_known?
      (@args - RatesFetcher::KNOWN_CURRENCIES).empty?
    end

    def direct_usd_conversion?
      @args.include?('usd')
    end
  end
end
