describe Exchange do
  let (:money)    { Money(1, 'PLN') }
  let (:exchange) { Exchange.new }

  describe '#convert' do
    context 'when currencies are valid' do
      before { allow(Rates).to receive(:index).with('PLN', 'EUR').and_return(4.0) }

      it 'returns correct value' do
        expect(exchange.convert(money, 'EUR')).to eq(4.0)
      end
    end

    context 'when a currency is invalid' do
      it 'raises InvalidCurrency exception' do
        expect { exchange.convert(money, 'ZZZ') }.to raise_exception(InvalidCurrency, 'Unknown ratio: PLN/ZZZ')
      end
    end
  end
end
