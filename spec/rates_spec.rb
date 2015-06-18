describe Rates do
  let(:path) { File.expand_path('../fixtures/response', __FILE__) }
  let(:response) { StringIO.new(File.read(path))}

  describe '#index' do
    before { allow(RatesFetcher).to receive(:response).and_return(response) }
    it { expect(Rates.index('pln', 'eur')).to be_instance_of(BigDecimal) }
    it { expect(Rates.index('pln', 'eur').to_s).to match(/\d+\.\d+/) }
  end

  describe 'Rates(base_currency, target_currency)' do
    it { expect(Rates('pln', 'usd')).to eq( Rates.index('pln', 'usd') ) }
  end
end
