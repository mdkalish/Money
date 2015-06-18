describe Exchange do
  let(:path) { File.expand_path('../fixtures/response', __FILE__) }
  let(:response) { StringIO.new(File.read(path)) }
  before { allow(RatesFetcher).to receive(:response).and_return(response) }
  after { RatesFetcher.instance_variable_set(:@response, nil) }
  describe '#convert' do
    let (:exchange) { Exchange.new }
    let (:ten_pln) { Money(10, 'PLN') }
    let (:ten_yyy) { Money(10, 'yyy') }
    let (:bd_ten) { BigDecimal('10') }
    context 'when neither currency is USD' do
      context 'when both currencies are valid (PLN/EUR)' do
        it { expect(exchange.convert(ten_pln, 'EUR')).to eq(BigDecimal('2.4')) }
      end

      context 'when base currency is invalid (yyy)' do
        it { expect { exchange.convert(ten_yyy, 'pln') }.to raise_exception(InvalidCurrency, 'Unknown ratio: YYY/PLN') }
      end

      context 'when target currency is invalid (ZZZ)' do
        it { expect { exchange.convert(ten_pln, 'ZZZ') }.to raise_exception(InvalidCurrency, 'Unknown ratio: PLN/ZZZ') }
      end

      context 'when both currencies are invalid (yyy/ZZZ)' do
        it { expect { exchange.convert(ten_yyy, 'ZZZ') }.to raise_exception(InvalidCurrency, 'Unknown ratio: YYY/ZZZ') }
      end
    end

    context 'when one currency is USD' do
      let(:ten_usd) { Money(10, 'usd') }
      context 'when usd is base currency' do
        context 'when target currency is valid (pln)' do
          it { expect(exchange.convert(ten_usd, 'pln')).to eq(bd_ten * BigDecimal('3.684803')) }
        end

        context 'when target currency is invalid (zzz)' do
          it { expect { exchange.convert(ten_usd, 'zzz') }.to raise_exception(InvalidCurrency, 'Unknown ratio: USD/ZZZ') }
        end
      end

      context 'when usd is target currency' do
        let(:ten_chf) { Money(10, 'chf') }
        context 'when base currency is valid (chf)' do
          it { expect(exchange.convert(ten_chf, 'usd')).to be_within(0.00001).of(bd_ten / BigDecimal('0.929404')) }
        end

        context 'when base currency is invalid (yyy)' do
          it { expect { exchange.convert(ten_yyy, 'usd') }.to raise_exception(InvalidCurrency, 'Unknown ratio: YYY/USD') }
        end
      end
    end

    context 'when both currencies are the same' do
      let(:ten_gbp) { Money(10, 'gbp') }
      context 'when currency is valid' do
        it 'returns the same amount' do
          expect(exchange.convert(ten_gbp, 'gbp')).to eq(bd_ten)
        end
      end

      context 'when currency is invalid' do
        it { expect { exchange.convert(ten_yyy, 'yyy') }.to raise_exception(InvalidCurrency, 'Unknown ratio: YYY/YYY') }
      end
    end
  end
end
