require 'money'

describe Money do
  let(:money) { Money.new(10, 'pln') }

  describe '::new' do
    it 'raises error if no currency is given' do
      expect { Money.new(10) }.to raise_error
    end

    it 'raises error if no amount is given' do
      expect { Money.new('usd') }.to raise_error
    end
  end

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

    it 'returns correct class instance' do
      expect(money_2).to be_instance_of(Money)
    end

    it 'returns correct value' do
      expect(money_2.inspect).to eq("#<Money 10 USD>")
    end

    it 'raises error if no currency is given' do
      expect{ Money(10) }.to raise_error
    end

    it 'raises error if no amount is given' do
      expect{ Money('usd') }.to raise_error
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

  describe 'comparing' do
    describe '#==' do
      it 'returns true for equal values' do
        expect(money == Money(10, 'pln')).to be_truthy
      end

      context 'when amount is different' do
        it 'returns false for unequal value' do
          expect(money == Money(11, 'pln')).to be_falsey
        end
      end

      context 'when currency is different' do
        before { allow(Rates).to receive(:index).with('GBP', 'PLN').and_return(5.5) }

        it 'returns false for unequal value' do
          expect(money == Money(10, 'gbp')).to be_falsey
        end
      end
    end

    describe '#>' do
      it 'returns false for equal values' do
        expect(money > Money(10, 'pln')).to be_falsey
      end

      context 'when first value is greater in amount' do
        it 'returns true' do
          expect(money > Money(9, 'pln')).to be_truthy
        end
      end

      context 'when first value is greater by currency' do
        before { allow(Rates).to receive(:index).with('PLN', 'GBP').and_return(0.2) }
        it 'returns true' do
          expect(Money(10, 'gbp') > money).to be_truthy
        end
      end

      context 'when values are same at different currencies' do
        before { allow(Rates).to receive(:index).with('EUR', 'CHF').and_return(1.0) }

        it 'returns false' do
          expect(Money(10, 'chf') > Money(10, 'eur')).to be_falsey
        end
      end
    end

    describe '#>=' do
      it 'returns true for equal values' do
        expect(money >= Money(10, 'pln')).to be_truthy
      end

      context 'when first value is greater in amount' do
        it 'returns true' do
          expect(money >= Money(9, 'pln')).to be_truthy
        end
      end

      context 'when first value is greater by currency' do
        before { allow(Rates).to receive(:index).with('PLN', 'GBP').and_return(0.2) }

        it 'returns true' do
          expect(Money(10, 'gbp') >= money).to be_truthy
        end
      end

      context 'when values are same at different currencies' do
        before { allow(Rates).to receive(:index).with('EUR', 'CHF').and_return(1.0) }

        it 'returns true' do
          expect(Money(10, 'chf') >= Money(10, 'eur')).to be_truthy
        end
      end
    end

    describe '#<=>' do
      context 'when currencies are the same' do
        context 'when values are equal' do
          it 'returns 0' do
            expect(money <=> Money(10, 'pln')).to eq(0)
          end
        end

        context 'when first value is less than the other' do
          it 'returns -1' do
            expect(money <=> Money(11, 'pln')).to eq(-1)
          end
        end

        context 'when first value is greater than the other' do
          it 'returns 1' do
            expect(money <=> Money(9, 'pln')).to eq(1)
          end
        end
      end

      context 'when currencies are different' do
        before { allow(Rates).to receive(:index).with('EUR', 'CHF').and_return(1.0) }

        context 'when values are equal' do
          it 'returns 0' do
            expect(Money(10, 'chf') <=> Money(10, 'eur')).to eq(0)
          end
        end

        context 'when first value is less than the other' do
          it 'returns -1' do
            expect(Money(9, 'chf') <=> Money(10, 'eur')).to eq(-1)
          end
        end

        context 'when first value is greater than the other' do
          it 'returns 1' do
            expect(Money(10, 'chf') <=> Money(9, 'eur')).to eq(1)
          end
        end
      end
    end
  end

  describe '::using_default_currency' do
    describe '::new()' do
      context 'when called in the block' do
        it 'evaluates correctly to default_currency' do
          Money.using_default_currency('usd') do
            expect(Money.new(10).inspect).to eq('#<Money 10 USD>')
          end
        end

        it 'evaluates correctly to args currency' do
          Money.using_default_currency('usd') do
            expect(Money.new(10, 'pln').inspect).to eq('#<Money 10 PLN>')
          end
        end

        context 'when called in a nested block' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money.new(10).inspect).to eq('#<Money 10 EUR>')
              end
            end
          end
        end

        context 'when called after nested block has been evaluated' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money.new(10).inspect).to eq('#<Money 10 EUR>')
              end
              expect(Money.new(9).inspect).to eq('#<Money 9 USD>')
            end
          end
        end
      end

      context 'when called outside the block' do
        before do
          begin
            Money.using_default_currency('usd') { fail }
          rescue
          end
        end

        it 'raises NoMethodError after other block failed to yield' do
          expect { Money.new(10) }.to raise_error(NoMethodError)
        end
      end
    end

    describe 'Money()' do
      context 'when called in the block' do
        it 'evaluates correctly to default_currency' do
          Money.using_default_currency('usd') do
            expect(Money(10).inspect).to eq('#<Money 10 USD>')
          end
        end

        it 'evaluates correctly to args currency' do
          Money.using_default_currency('usd') do
            expect(Money(10, 'pln').inspect).to eq('#<Money 10 PLN>')
          end
        end

        context 'when called in a nested block' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money(10).inspect).to eq('#<Money 10 EUR>')
              end
            end
          end
        end

        context 'when called after nested block has been evaluated' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money(10).inspect).to eq('#<Money 10 EUR>')
              end
              expect(Money(9).inspect).to eq('#<Money 9 USD>')
            end
          end
        end
      end

      context 'when called outside the block' do
        before do
          begin
            Money.using_default_currency('usd') { fail }
          rescue
          end
        end

        it 'raises NoMethodError after other block failed to yield' do
          expect { Money(10) }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
