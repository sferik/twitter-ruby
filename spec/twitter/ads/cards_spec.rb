require 'helper'

describe Twitter::Ads::Cards do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  context 'lead gen' do;end

  context 'app' do;end

  context 'app image' do;end

  context 'website' do
    context '#website_cards' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/abc1/cards/website')
          .to_return(body: fixture('cards/websites.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resources' do
        @client.website_cards('abc1')
        expect(a_get('https://ads-api.twitter.com/0/accounts/abc1/cards/website')).to have_been_made
      end
      it 'gets the right resources'do
        cards = @client.website_cards('abc1')
        expect(cards.first).to be_a(Twitter::Card::Website)
        expect(cards.map(&:id)).to match(['g9z'])
      end
    end

    context '#website_card' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/abc1/cards/website/g9z')
          .to_return(body: fixture('cards/website.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resoruce' do
        @client.website_card('abc1', 'g9z')
        expect(a_get('https://ads-api.twitter.com/0/accounts/abc1/cards/website/g9z')).to have_been_made
      end
      it 'gets the right resource' do
        card = @client.website_card('abc1', 'g9z')
        expect(card).to be_a(Twitter::Card::Website)
        expect(card.id).to eq('g9z')
      end
    end

    context '#create_website_card' do
      let(:expected) do
        {
          name: 'Test Website Card 1',
          website_url: 'https://support.twitter.com/',
          website_title: 'Twitter Help Center',
          website_cta: 'READ_MORE',
          image_media_id: 'abc123',
        }
      end
      before do
        stub_post('https://ads-api.twitter.com/0/accounts/abc1/cards/website').with(body: expected)
          .to_return(body: fixture('cards/website_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.create_website_card('abc1', expected[:name], expected[:website_title], expected[:website_url], expected[:image_media_id], {website_cta: expected[:website_cta]})
        expect(a_post('https://ads-api.twitter.com/0/accounts/abc1/cards/website').with(body: expected)).to have_been_made
      end
      it 'creates a website card' do
        card = @client.create_website_card('abc1', expected[:name], expected[:website_title], expected[:website_url], expected[:image_media_id], {website_cta: expected[:website_cta]})
        expect(card).to be_a(Twitter::Card::Website)
        expect(card.id).to eq('g9z')
      end
    end

    context '#update_website_card' do
      let(:expected) do
        {
          name: 'Test Website Card 1a',
          website_title: 'Twitter Help Center Home',
        }
      end
      before do
        stub_put('https://ads-api.twitter.com/0/accounts/abc1/cards/website/g9z').with(body: expected)
          .to_return(body: fixture('cards/website_put.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.update_website_card('abc1', 'g9z', expected)
        expect(a_put('https://ads-api.twitter.com/0/accounts/abc1/cards/website/g9z').with(body: expected)).to have_been_made
      end
      it 'updates the card' do
        card = @client.update_website_card('abc1', 'g9z', expected)
        expect(card).to be_a(Twitter::Card::Website)
        expect(card.name).to eq(expected[:name])
      end
    end

    context '#destroy_website_card' do
      before do
        stub_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/website/gn6')
          .to_return(body: fixture('cards/website_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.destroy_website_card('abc1', 'gn6')
        expect(a_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/website/gn6')).to have_been_made
      end
      it 'deletes the correct resource' do
        card = @client.destroy_website_card('abc1', 'gn6')
        expect(card.id).to eq('gn6')
        expect(card).to be_deleted
      end
    end
  end
end
