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
end
