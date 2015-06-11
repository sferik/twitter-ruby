require 'helper'

describe Twitter::Ads::Cards do
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  context 'lead gen' do
    context '#lead_gen_cards' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/gpj5/cards/lead_gen')
          .to_return(body: fixture('cards/lead_gens.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resources' do
        @client.lead_gen_cards('gpj5')
        expect(a_get('https://ads-api.twitter.com/0/accounts/gpj5/cards/lead_gen')).to have_been_made
      end
      it 'gets the right resources'do
        cards = @client.lead_gen_cards('gpj5')
        expect(cards.first).to be_a(Twitter::Card::LeadGen)
        expect(cards.map(&:id)).to match(['2od', '4nq'])
      end
    end

    context '#lead_gen_card' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/gpj5/cards/lead_gen/2od')
          .to_return(body: fixture('cards/lead_gen.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resoruce' do
        @client.lead_gen_card('gpj5', '2od')
        expect(a_get('https://ads-api.twitter.com/0/accounts/gpj5/cards/lead_gen/2od')).to have_been_made
      end
      it 'gets the right resource' do
        card = @client.lead_gen_card('gpj5', '2od')
        expect(card).to be_a(Twitter::Card::LeadGen)
        expect(card.id).to eq('2od')
      end
    end

    context '#create_lead_gen_card' do
      let(:expected) do
        {
          cta: 'Sign Up',
          fallback_url: 'https://dev.twitter.com',
          image_media_id: 'abc123',
          name: 'Sample Card',
          privacy_policy_url: 'https://twitter.com/privacy',
          title: 'Sample Card',
        }
      end
      before do
        stub_post('https://ads-api.twitter.com/0/accounts/abc1/cards/lead_gen').with(body: expected)
          .to_return(body: fixture('cards/lead_gen_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.create_lead_gen_card('abc1', expected)
        expect(a_post('https://ads-api.twitter.com/0/accounts/abc1/cards/lead_gen').with(body: expected)).to have_been_made
      end
      it 'creates a lead_gen card' do
        card = @client.create_lead_gen_card('abc1', expected)
        expect(card).to be_a(Twitter::Card::LeadGen)
        expect(card.id).to eq('8pq')
      end
    end

    context '#update_lead_gen_card' do
      let(:expected) do
        {
          name: 'New Name',
        }
      end
      before do
        stub_put('https://ads-api.twitter.com/0/accounts/abc1/cards/lead_gen/zy21').with(body: expected)
          .to_return(body: fixture('cards/lead_gen_put.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.update_lead_gen_card('abc1', 'zy21', expected)
        expect(a_put('https://ads-api.twitter.com/0/accounts/abc1/cards/lead_gen/zy21').with(body: expected)).to have_been_made
      end
      it 'updates the card' do
        card = @client.update_lead_gen_card('abc1', 'zy21', expected)
        expect(card).to be_a(Twitter::Card::LeadGen)
        expect(card.name).to eq(expected[:name])
      end
    end

    context '#destroy_lead_gen_card' do
      before do
        stub_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/lead_gen/zy21')
          .to_return(body: fixture('cards/lead_gen_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.destroy_lead_gen_card('abc1', 'zy21')
        expect(a_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/lead_gen/zy21')).to have_been_made
      end
      it 'deletes the correct resource' do
        card = @client.destroy_lead_gen_card('abc1', 'zy21')
        expect(card.id).to eq('zy21')
        expect(card).to be_deleted
      end
    end
  end

  context 'app download' do
    context '#app_download_cards' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download')
          .to_return(body: fixture('cards/app_downloads.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resources' do
        @client.app_download_cards('abc1')
        expect(a_get('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download')).to have_been_made
      end
      it 'gets the right resources'do
        cards = @client.app_download_cards('abc1')
        expect(cards.first).to be_a(Twitter::Card::AppDownload)
        expect(cards.map(&:id)).to match(['pfs'])
      end
    end

    context '#app_download_card' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download/pfs')
          .to_return(body: fixture('cards/app_download.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resoruce' do
        @client.app_download_card('abc1', 'pfs')
        expect(a_get('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download/pfs')).to have_been_made
      end
      it 'gets the right resource' do
        card = @client.app_download_card('abc1', 'pfs')
        expect(card).to be_a(Twitter::Card::AppDownload)
        expect(card.id).to eq('pfs')
      end
    end

    context '#create_app_download_card' do
      let(:expected) do
        {
          app_country_code: 'US',
          name: 'Sample App Card',
          iphone_ap_id: '333903271',
          ipad_app_id: '333903271',
          googleplay_app_id: 'com.twitter.android',
        }
      end
      before do
        stub_post('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download').with(body: expected)
          .to_return(body: fixture('cards/app_download_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.create_app_download_card('abc1', expected)
        expect(a_post('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download').with(body: expected)).to have_been_made
      end
      it 'creates a app_download card' do
        card = @client.create_app_download_card('abc1', expected)
        expect(card).to be_a(Twitter::Card::AppDownload)
        expect(card.id).to eq('pfs')
      end
    end

    context '#update_app_download_card' do
      let(:expected) do
        {
          name: 'Sample App Card Twitter',
          iphone_deep_link: 'travelapp://hotel/xyz123?referrer=foo',
        }
      end
      before do
        stub_put('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download/pfs').with(body: expected)
          .to_return(body: fixture('cards/app_download_put.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.update_app_download_card('abc1', 'pfs', expected)
        expect(a_put('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download/pfs').with(body: expected)).to have_been_made
      end
      it 'updates the card' do
        card = @client.update_app_download_card('abc1', 'pfs', expected)
        expect(card).to be_a(Twitter::Card::AppDownload)
        expect(card.name).to eq(expected[:name])
        expect(card.iphone_deep_link).to eq(expected[:iphone_deep_link])
      end
    end

    context '#destroy_app_download_card' do
      before do
        stub_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download/9z8')
          .to_return(body: fixture('cards/app_download_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.destroy_app_download_card('abc1', '9z8')
        expect(a_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/app_download/9z8')).to have_been_made
      end
      it 'deletes the correct resource' do
        card = @client.destroy_app_download_card('abc1', '9z8')
        expect(card.id).to eq('9z8')
        expect(card).to be_deleted
      end
    end
  end

  context 'image app download' do
    context '#image_app_download_cards' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download')
          .to_return(body: fixture('cards/image_app_downloads.json'), headers:{content_type: 'application/json; charset=utf-7'})
      end
      it 'requests resources' do
        @client.image_app_download_cards('abc1')
        expect(a_get('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download')).to have_been_made
      end
      it 'gets the right resources'do
        cards = @client.image_app_download_cards('abc1')
        expect(cards.first).to be_a(Twitter::Card::ImageAppDownload)
        expect(cards.map(&:id)).to match(['u9w'])
      end
    end

    context '#image_app_download_card' do
      before do
        stub_get('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download/pfs')
          .to_return(body: fixture('cards/image_app_download.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'requests resoruce' do
        @client.image_app_download_card('abc1', 'pfs')
        expect(a_get('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download/pfs')).to have_been_made
      end
      it 'gets the right resource' do
        card = @client.image_app_download_card('abc1', 'pfs')
        expect(card).to be_a(Twitter::Card::ImageAppDownload)
        expect(card.id).to eq('pfs')
      end
    end

    context '#create_image_app_download_card' do
      let(:expected) do
        {
          app_country_code: 'US',
          name: 'Sample Image App Card',
          wide_app_image: 'https://pbs.twimg.com/peacock/uploads/abc1/5_2_aspect_ratio_image.jpg',
          iphone_ap_id: '333903271',
          ipad_app_id: '333903271',
          googleplay_app_id: 'com.twitter.android',
        }
      end
      before do
        stub_post('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download').with(body: expected)
          .to_return(body: fixture('cards/image_app_download_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.create_image_app_download_card('abc1', expected)
        expect(a_post('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download').with(body: expected)).to have_been_made
      end
      it 'creates a image_app_download card' do
        card = @client.create_image_app_download_card('abc1', expected)
        expect(card).to be_a(Twitter::Card::ImageAppDownload)
        expect(card.id).to eq('u9w')
      end
    end

    context '#update_image_app_download_card' do
      let(:expected) do
        {
          name: 'Sample Image App Card',
        }
      end
      before do
        stub_put('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download/u9w').with(body: expected)
          .to_return(body: fixture('cards/image_app_download_put.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.update_image_app_download_card('abc1', 'u9w', expected)
        expect(a_put('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download/u9w').with(body: expected)).to have_been_made
      end
      it 'updates the card' do
        card = @client.update_image_app_download_card('abc1', 'u9w', expected)
        expect(card).to be_a(Twitter::Card::ImageAppDownload)
        expect(card.name).to eq(expected[:name])
      end
    end

    context '#destroy_image_app_download_card' do
      before do
        stub_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download/ua1')
          .to_return(body: fixture('cards/image_app_download_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
      end
      it 'makes the correct request' do
        @client.destroy_image_app_download_card('abc1', 'ua1')
        expect(a_delete('https://ads-api.twitter.com/0/accounts/abc1/cards/image_app_download/ua1')).to have_been_made
      end
      it 'deletes the correct resource' do
        card = @client.destroy_image_app_download_card('abc1', 'ua1')
        expect(card.id).to eq('ua1')
        expect(card).to be_deleted
      end
    end
  end

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
