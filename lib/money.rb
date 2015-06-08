$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'exchange'

class Money
  attr_reader :amount, :currency
  include Comparable

  def initialize(amount, currency = Money.default_currency)
    @amount = amount.to_i
    @currency = currency.upcase
  end

  def to_s
    "#{@amount} #{@currency}"
  end

  def inspect
    "#<#{self.class} #{to_s}>"
  end

  class << self
    attr_accessor :default_currency

    ['usd', 'eur', 'gbp'].each do |currency|
      define_method("from_#{currency}") do |arg|
        Money.new(arg, currency)
      end
    end
  end

  def self.exchange
    Exchange.new
  end

  def exchange_to(currency)
    self.class.exchange.convert(self, currency)
  end

  def <=>(anOther)
    self.amount <=> anOther.exchange_to(self.currency)
  end

  def self.using_default_currency(default_currency, &block)
    super_default_currency = self.default_currency
    self.default_currency = default_currency
    y = yield
    self.default_currency = super_default_currency
    y
  end
end

class Object
  def Money(amount, currency = Money.default_currency)
    Money.new(amount, currency)
  end
end
