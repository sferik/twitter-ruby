require 'helper'

describe Twitter::Ads::FundingInstruments do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#funding_instruments' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/funding_instruments').to_return(body: fixture('funding_instruments.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.funding_instruments('hkk5')
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/funding_instruments')).to have_been_made
    end
    it 'gets the right resources' do
      funding_instruments = @client.funding_instruments('hkk5')
      expect(funding_instruments.map(&:id)).to match(['hw6ie'])
    end
  end

  describe '#funding_instrument' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/funding_instruments/hw6ie').to_return(body: fixture('funding_instrument_get.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resoruce' do
      @client.funding_instrument('hkk5', 'hw6ie')
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/funding_instruments/hw6ie')).to have_been_made
    end
    it 'gets the correct resource' do
      funding_instrument = @client.funding_instrument('hkk5', 'hw6ie')
      expect(funding_instrument).to be_a Twitter::FundingInstrument
      expect(funding_instrument.id).to eq('hw6ie')
    end
  end
end
