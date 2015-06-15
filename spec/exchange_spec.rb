describe Exchange do
  describe '#convert' do
    let (:money)    { Money(2.0, 'PLN') }
    let (:exchange) { Exchange.new }

    context 'when currencies are valid' do
      let(:rate) { BigDecimal('4.0') }
      before { allow(Rates).to receive(:index).with('PLN', 'EUR').and_return(rate) }

      it 'returns correct value' do
        expect(exchange.convert(money, 'EUR')).to eq(8.0)
      end
    end

    context 'when a currency is invalid' do
      it 'raises InvalidCurrency exception' do
        expect { exchange.convert(money, 'ZZZ') }.to raise_exception(InvalidCurrency, 'Unknown ratio: PLN/ZZZ')
      end
    end
  end
end
