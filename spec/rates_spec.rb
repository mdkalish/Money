describe Rates do
  describe '#index' do
    it 'returns correct ratio' do
      expect(Rates.index('pln', 'eur')).to be_instance_of(Float)
      expect(Rates.index('pln', 'eur').to_s).to match(/\d+\.\d+/)
    end
  end

  describe 'Rates(c1, c2)' do
    before { allow(Rates).to receive(:index).with('pln', 'usd').and_return(0.3) }

    it 'returns correct ratio' do
      expect(Rates('pln', 'usd')).to eq(0.3)
    end
  end
end
