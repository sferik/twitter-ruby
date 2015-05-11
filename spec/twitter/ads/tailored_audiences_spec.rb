require 'helper'

describe Twitter::Ads::TailoredAudiences do
  let(:account_id) {'abc1'}
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#tailored_audiences' do
    before do
      stub_get("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences")
        .to_return(body: fixture('tailored_audiences.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.tailored_audiences(account_id)
      expect(a_get("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences")).to have_been_made
    end
    it 'gets the right resources' do
      audiences = @client.tailored_audiences(account_id)
      expect(audiences.count).to eq(7)
      expect(audiences.map(&:id)).to match(['1', '2qr', 'br7', 'jy6', 'k19', 'k26', 's63'])
    end
  end

  describe '#tailored_audience' do
    before do
      stub_get("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences/br7")
        .to_return(body: fixture('tailored_audience_get.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.tailored_audience(account_id, 'br7')
      expect(a_get("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences/br7")).to have_been_made
    end
    it 'gets the right resource' do
      audience = @client.tailored_audience(account_id, 'br7')
      expect(audience).to be_a Twitter::TailoredAudience
      expect(audience.id).to eq('br7')
    end
  end

  describe '#create_tailored_audience' do
    let(:expected) do
      {
        name: 'Sample Twitter ID Audience',
        list_type: 'TWITTER_ID',
      }
    end
    before do
      stub_post("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences")
        .with(body: expected).to_return(body: fixture('tailored_audience_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'creates a line item' do
      audience = @client.create_tailored_audience(account_id, expected[:name], expected[:list_type])
      expect(audience).to be_a(Twitter::TailoredAudience)
      expect(audience.id).to eq('13sf')
    end
  end

  describe '#destroy_tailored_audience' do
    before do
      stub_delete("https://ads-api.twitter.com/0/accounts/#{account_id}/tailored_audiences/13si")
        .to_return(body: fixture('tailored_audience_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'deletes the tailored audience' do
      audience = @client.destroy_tailored_audience(account_id, '13si')
      expect(audience).to be_a(Twitter::TailoredAudience)
      expect(audience.id).to eq('13si')
    end
  end

  describe '#tailored_audience_changes' do
  end

  describe '#tailored_audience_change' do
  end

  describe '#change_tailored_audience' do
  end

  describe '#tailored_audience_opt_out' do
  end
end
