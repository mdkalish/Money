class Rates
  KNOWN_CURRENCIES = ["usd", "eur", "gbp", "chf", "jpy", "pln"]

  def self.index(c1, c2)
    c1.upcase!; c2.upcase!
    {
      "USD_USD"=>1,
      "USD_EUR"=>0.8896,
      "USD_GBP"=>0.6506,
      "USD_CHF"=>0.9337,
      "USD_JPY"=>124.3545,
      "USD_PLN"=>3.709,
      "EUR_USD"=>1.1239,
      "EUR_EUR"=>1,
      "EUR_GBP"=>0.7313,
      "EUR_CHF"=>1.0495,
      "EUR_JPY"=>139.7545,
      "EUR_PLN"=>4.1683,
      "GBP_USD"=>1.5367,
      "GBP_EUR"=>1.3674,
      "GBP_GBP"=>1,
      "GBP_CHF"=>1.4343,
      "GBP_JPY"=>191.355,
      "GBP_PLN"=>5.6999,
      "CHF_USD"=>1.0716,
      "CHF_EUR"=>0.9529,
      "CHF_GBP"=>0.6975,
      "CHF_CHF"=>1,
      "CHF_JPY"=>133.3307,
      "CHF_PLN"=>3.9761,
      "JPY_USD"=>0.008,
      "JPY_EUR"=>0.0072,
      "JPY_GBP"=>0.0052,
      "JPY_CHF"=>0.0075,
      "JPY_JPY"=>1,
      "JPY_PLN"=>0.0298,
      "PLN_USD"=>0.2699,
      "PLN_EUR"=>0.2397,
      "PLN_GBP"=>0.1754,
      "PLN_CHF"=>0.2521,
      "PLN_JPY"=>33.5366,
      "PLN_PLN"=>1
    }["#{c1}_#{c2}"]
  end
end

class Object
  def Rates(c1, c2)
    Rates.index(c1, c2)
  end
end
