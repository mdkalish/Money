module CurrencyConverter
  class Money
    include Comparable
    KNOWN_CURRENCIES = RatesFetcher::KNOWN_CURRENCIES
    CONVERSIONS = KNOWN_CURRENCIES.map { |c| "to_#{c}" }
    attr_reader :amount, :currency

    class << self
      attr_accessor :default_currency
      KNOWN_CURRENCIES.each do |currency|
        define_method("from_#{currency}") do |arg|
          Money.new(arg, currency)
        end
      end
    end

    def self.exchange
      Exchange.new
    end

    def self.using_default_currency(default_currency, &block)
      super_default_currency = self.default_currency
      self.default_currency = default_currency
      y = yield
    ensure
      self.default_currency = super_default_currency
      y
    end

    def initialize(amount, currency = Money.default_currency)
      @amount = BigDecimal(amount.to_s)
      @currency = currency.upcase
    end

    def to_s
      "#{@amount.to_digits} #{@currency}"
    end

    def inspect
      "#<#{self.class} #{to_s}>"
    end

    def exchange_to(currency)
      self.class.exchange.convert(self, currency)
    end

    def <=>(anOther)
      self.amount <=> anOther.exchange_to(self.currency)
    end

    def method_missing(method_sym)
      method = method_sym.to_s
      CONVERSIONS.include?(method) ? exchange_to(method[3,3]) : super
    end

    def respond_to?(method_sym, include_private = false)
      CONVERSIONS.include?(method_sym.to_s) ? true : super
    end

    def +(anOther)
      result = self.amount + anOther.exchange_to(self.currency)
      Money(result, self.currency)
    end

    def *(number)
      Money(self.amount * number, self.currency)
    end
  end
end

class Object
  def Money(amount, currency = Money.default_currency)
    CurrencyConverter::Money.new(amount, currency)
  end
end
