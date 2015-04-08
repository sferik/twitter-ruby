require 'helper'

describe Twitter::Ads::Campaigns do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#campaigns' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/campaigns').to_return(body: fixture('campaigns.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.campaigns('hkk5')
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/campaigns')).to have_been_made
    end
    it 'gets the right resources' do
      campaigns = @client.campaigns('hkk5')
      expect(campaigns.map(&:id)).to match(['7jem', '7wdy'])
    end
  end

  describe '#campaign' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/campaigns/8zwv').to_return(body: fixture('campaign_get.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resoruce' do
      @client.campaign('hkk5', '8zwv')
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/campaigns/8zwv')).to have_been_made
    end
    it 'gets the correct resource' do
      campaign = @client.campaign('hkk5', '8zwv')
      expect(campaign).to be_a Twitter::Campaign
      expect(campaign.id).to eq('8zwv')
    end
  end

  describe '#update_campaign' do
    before do
      stub_put('https://ads-api.twitter.com/0/accounts/hkk5/campaigns/8zwv').with(body: {'name' => 'Important', 'paused' => 'true'}).to_return(body: fixture('campaign_put.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'updates the correct resource' do
      @client.update_campaign('hkk5', '8zwv', name: 'Important', paused: true)
      expect(a_put('https://ads-api.twitter.com/0/accounts/hkk5/campaigns/8zwv')).to have_been_made
    end
    it 'gets the updated campaign' do
      campaign = @client.update_campaign('hkk5', '8zwv', name: 'Important', paused: true)
      expect(campaign).to be_a Twitter::Campaign
      expect(campaign.name).to eq('Important')
      expect(campaign).to be_paused
    end
  end

  describe '#destroy_campaign' do
    before do
      stub_delete('https://ads-api.twitter.com/0/accounts/hkk5/campaigns/8zwv').to_return(body: fixture('campaign_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'deletes the correct resource' do
      @client.destroy_campaign('hkk5', '8zwv')
      expect(a_delete('https://ads-api.twitter.com/0/accounts/hkk5/campaigns/8zwv')).to have_been_made
    end
  end
end
