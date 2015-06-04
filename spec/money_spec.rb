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
      ['USD', 'EUR', 'GBP'].each do |currency|
        method = "from_#{currency.downcase}".to_sym
        expect(Money.send(method, 10).inspect).to eq("#<Money 10 #{currency}>")
      end
    end
  end

  describe 'Money(amount, currency)' do
    let (:money_2) { Money(10, 'usd') }

    it 'returns correct object' do
      expect(money_2.class).to eq(Money)
    end

    it 'returns correct value' do
      expect(money_2.inspect).to eq("#<Money 10 USD>")
    end
  end

  describe 'exchanging' do
    context 'when currencies are valid' do
      before { allow(Rates).to receive(:index).and_return(40.0) }

      describe '::exchange' do
        it 'returns correct value' do
          expect(Money.exchange.convert(money, 'USD')).to eq(400.0)
        end
      end

      describe '#exchange_to' do
        it 'returns correct value' do
          expect(money.exchange_to('USD')).to eq(400.0)
        end
      end
    end

    context 'when a currency is invalid' do
      describe '::exchange' do
        it 'raises InvalidCurrency exception' do
          expect { Money.exchange.convert(money, 'XXX') }.to raise_exception(InvalidCurrency, 'Unknown ratio: PLN/XXX')
        end
      end

      describe '#exchange_to' do
        it 'raises InvalidCurrency exception' do
          expect { money.exchange_to('YYY') }.to raise_exception(InvalidCurrency, 'Unknown ratio: PLN/YYY')
        end
      end
    end
  end
end
