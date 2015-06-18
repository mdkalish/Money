describe Money do
  KNOWN_CURRENCIES = RatesFetcher::KNOWN_CURRENCIES
  CONVERSIONS = Money::CONVERSIONS
  let(:money) { Money.new(10.54, 'pln') }
  let(:rate) { BigDecimal('2.0') }
  describe '::new' do
    context 'when no currency is given' do
      it { expect { Money.new(10) }.to raise_error }
    end

    context 'when no amount is given' do
      it { expect { Money.new('usd') }.to raise_error }
    end
  end

  describe '#to_s' do
    it { expect(money.to_s).to eq('10.54 PLN') }
  end

  describe '#inspect' do
    it { expect(money.inspect).to eq('#<CurrencyConverter::Money 10.54 PLN>') }
  end

  describe 'Money(amount, currency)' do
    let (:money_2) { Money(10.55, 'usd') }
    it { expect(money_2).to be_instance_of(Money) }
    it { expect(money_2.inspect).to eq("#<CurrencyConverter::Money 10.55 USD>") }
    it 'raises error if no currency is given' do
      expect{ Money(10) }.to raise_error
    end
    it 'raises error if no amount is given' do
      expect{ Money('usd') }.to raise_error
    end
  end

  describe 'exchanging' do
    describe '::from_<currency>' do
      KNOWN_CURRENCIES.each do |currency|
        it { expect(Money).to respond_to("from_#{currency}") }
      end

      KNOWN_CURRENCIES.each do |currency|
        it { expect(Money.send("from_#{currency}", 10.3).inspect).to eq("#<CurrencyConverter::Money 10.3 #{currency.upcase}>") }
      end
    end

    describe '#to_<currency>' do
      let(:result) { BigDecimal('10.0') }
      let(:exchange) { instance_double('exchange') }
      before { allow(Exchange).to receive(:new).and_return(exchange) }
      before { allow(exchange).to receive(:convert).and_return(result) }

      CONVERSIONS.each do |conversion_method|
        it { expect(money.send(conversion_method)).to eq(result) }
      end

      it { expect { money.to_unknown }.to raise_error(NoMethodError) }

      CONVERSIONS.each do |conversion_method|
        it { expect(money).to respond_to(conversion_method) }
      end
    end

    describe '::exchange' do
      context 'when a currency is invalid' do
        it { expect { Money.exchange.convert(money, 'XXX') }.to raise_exception(InvalidCurrency, 'Unknown ratio: PLN/XXX') }
      end

      context 'when currencies are valid' do
        it do
          allow(Rates).to receive(:index).and_return(rate)
          expect(Money.exchange.convert(money, 'USD')).to eq(21.08)
        end
      end
    end

    describe '#exchange_to' do
      context 'when a currency is invalid' do
        it { expect { money.exchange_to('YYY') }.to raise_exception(InvalidCurrency, 'Unknown ratio: PLN/YYY') }
      end

      context 'when currencies are valid' do
        it do
          allow(Rates).to receive(:index).and_return(rate)
          expect(money.exchange_to('USD')).to eq(21.08)
        end
      end
    end
  end

  describe '::using_default_currency' do
    describe '::new()' do
      context 'when called in the block' do
        it 'evaluates correctly to default_currency' do
          Money.using_default_currency('usd') do
            expect(Money.new(10).inspect).to eq('#<CurrencyConverter::Money 10.0 USD>')
          end
        end

        it 'evaluates correctly to args currency' do
          Money.using_default_currency('usd') do
            expect(Money.new(10, 'pln').inspect).to eq('#<CurrencyConverter::Money 10.0 PLN>')
          end
        end

        context 'when called in a nested block' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money.new(10).inspect).to eq('#<CurrencyConverter::Money 10.0 EUR>')
              end
            end
          end
        end

        context 'when called after nested block has been evaluated' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money.new(10).inspect).to eq('#<CurrencyConverter::Money 10.0 EUR>')
              end
              expect(Money.new(9).inspect).to eq('#<CurrencyConverter::Money 9.0 USD>')
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
            expect(Money(10).inspect).to eq('#<CurrencyConverter::Money 10.0 USD>')
          end
        end

        it 'evaluates correctly to args currency' do
          Money.using_default_currency('usd') do
            expect(Money(10, 'pln').inspect).to eq('#<CurrencyConverter::Money 10.0 PLN>')
          end
        end

        context 'when called in a nested block' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money(10).inspect).to eq('#<CurrencyConverter::Money 10.0 EUR>')
              end
            end
          end
        end

        context 'when called after nested block has been evaluated' do
          it 'evaluates to default_currency set for correct block scope' do
            Money.using_default_currency('usd') do
              Money.using_default_currency('eur') do
                expect(Money(10).inspect).to eq('#<CurrencyConverter::Money 10.0 EUR>')
              end
              expect(Money(9).inspect).to eq('#<CurrencyConverter::Money 9.0 USD>')
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
