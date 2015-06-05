$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'exchange'

class Money
  attr_reader :amount, :currency
  include Comparable

  def initialize(amount, currency)
    @amount = amount
    @currency = currency.upcase
  end

  def to_s
    "#{@amount} #{@currency}"
  end

  def inspect
    "#<#{self.class} #{to_s}>"
  end

  class << self
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
end

class Object
  def Money(amount, currency)
    Money.new(amount, currency)
  end
end
