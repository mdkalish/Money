describe RatesFetcher do
  let(:rates_fetcher) { RatesFetcher }
  let(:path) { File.expand_path('../fixtures/response', __FILE__) }
  let(:response) { StringIO.new(File.read(path))}
  before { allow(rates_fetcher).to receive(:response).and_return(response) }

  describe '::response_json' do
    it { expect(rates_fetcher.response_json.keys).to include('success', 'quotes', 'timestamp') }
    it { expect(rates_fetcher.response_json).to include({'success'=>true}) }
    it 'contains 6 currencies' do
      expect(rates_fetcher.response_json.fetch('quotes').length).to eq(6)
    end
  end

  describe '::parse_response' do
    it { expect(rates_fetcher.parse_response).to respond_to(:keys) }
  end
end
