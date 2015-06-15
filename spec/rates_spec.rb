describe Rates do
  describe '#index' do
    it 'returns correct ratio' do
      expect(Rates.index('pln', 'eur')).to be_instance_of(BigDecimal)
      expect(Rates.index('pln', 'eur').to_s).to match(/\d+\.\d+/)
    end
  end

  describe 'Rates(c1, c2)' do
    let(:rate) { BigDecimal.new('0.3') }
    before { allow(Rates).to receive(:index).with('pln', 'usd').and_return(rate) }

    it 'returns correct ratio' do
      expect(Rates('pln', 'usd')).to eq(rate)
    end
  end
end
