class Money
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
end

class Object
  def Money(amount, currency)
    Money.new(amount, currency)
  end
end
