require 'helper'

describe Twitter::Ads::LineItems do
  let (:account_id) {'hkk5'}
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#line_items' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/line_items').to_return(body: fixture('line_items.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.line_items(account_id)
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/line_items')).to have_been_made
    end
    it 'gets the right resources' do
      line_items = @client.line_items(account_id)
      expect(line_items.map(&:id)).to match(['5woz'])
    end
  end

  describe '#line_item' do
    before do
      stub_get('https://ads-api.twitter.com/0/accounts/hkk5/line_items/69ob').to_return(body: fixture('line_item.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.line_item(account_id, '69ob')
      expect(a_get('https://ads-api.twitter.com/0/accounts/hkk5/line_items/69ob')).to have_been_made
    end
    it 'gets the right resources' do
      line_item = @client.line_item(account_id, '69ob')
      expect(line_item.id).to eq('69ob')
    end
  end

  describe '#create_line_item' do
    let(:args) do
      {
        bid_amount_local_micro: 100_000,
        placement_type: 'PROMOTED_TWEETS_FOR_SEARCH',
        objective: 'TWEET_ENGAGEMENTS',
        paused: true,
      }
    end
    let(:campaign_id) { '8lp0' }
    let(:expected) {args.reduce({}) {|l,r| l[r[0]] = r[1].to_s; l}.merge(campaign_id: '8lp0')}

    before do
      stub_post('https://ads-api.twitter.com/0/accounts/hkk5/line_items')
        .with(body: expected).to_return(body: fixture('line_item_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'creates a line item' do
      line_item = @client.create_line_item(account_id, campaign_id, args)
      expect(line_item).to be_a Twitter::LineItem
      expect(line_item.id).to eq('6zva')
    end
  end

  describe '#update_line_item' do
    let(:args) do
      {
        bid_amount_local_micro: 150_000,
      }
    end
    let(:expected) {args.reduce({}) {|l,r| l[r[0]] = r[1].to_s; l}}
    before do
      stub_put('https://ads-api.twitter.com/0/accounts/hkk5/line_items/6zva')
        .with(body: expected).to_return(body: fixture('line_item_put.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'updates a line item' do
      line_item = @client.update_line_item(account_id, '6zva', args)
      expect(line_item.bid_amount_local_micro).to eq(150_000)
      expect(a_put('https://ads-api.twitter.com/0/accounts/hkk5/line_items/6zva')).to have_been_made
    end
  end

  describe '#destroy_line_item' do
    before do
      stub_delete('https://ads-api.twitter.com/0/accounts/43853bhii879/line_items/43852jv8hlcjA')
        .to_return(body: fixture('line_item_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end

    it 'deletes the correct resource' do
      @client.destroy_line_item('43853bhii879', '43852jv8hlcjA')
      expect(a_delete('https://ads-api.twitter.com/0/accounts/43853bhii879/line_items/43852jv8hlcjA')).to have_been_made
    end
  end
end
