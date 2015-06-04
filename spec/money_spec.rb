require 'money'

describe Money do
  let(:money) { Money.new(10, 'pln') }

  describe '#to_s' do
    it 'returns correct string' do
      expect(money.to_s).to eq('10 PLN')
    end
  end

  describe '#inspect' do
    it 'returns correct string' do
      expect(money.inspect).to eq('#<Money 10 PLN>')
    end
  end

  describe 'meta methods' do
    let(:Money) { Money }

    it 'exist and respond' do
      ['usd', 'eur', 'gbp'].each do |currency|
        method = "from_#{currency}"
        expect(Money).to respond_to(method)
      end
    end

    it 'return correct value' do
      ['usd', 'eur', 'gbp'].each do |currency|
        method = "from_#{currency}".to_sym
        expect(Money.send(method, 10).inspect).to eq("#<Money 10 #{currency.upcase}>")
      end
    end
  end

  describe 'notation Money(amount, currency)' do
    let (:money) { Money(10, 'usd') }

    it 'returns correct object' do
      expect(money.class).to eq(Money)
    end

    it 'returns correct value' do
      expect(money.inspect).to eq("#<Money 10 USD>")
    end
  end
end
