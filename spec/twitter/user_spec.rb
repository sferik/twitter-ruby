require 'helper'

describe Twitter::User do
  describe '#==' do
    it 'returns true when objects IDs are the same' do
      user = Twitter::User.new(id: 1, screen_name: 'foo')
      other = Twitter::User.new(id: 1, screen_name: 'bar')
      expect(user == other).to be true
    end
    it 'returns false when objects IDs are different' do
      user = Twitter::User.new(id: 1)
      other = Twitter::User.new(id: 2)
      expect(user == other).to be false
    end
    it 'returns false when classes are different' do
      user = Twitter::User.new(id: 1)
      other = Twitter::Identity.new(id: 1)
      expect(user == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created_at is set' do
      user = Twitter::User.new(id: 7_505_382, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(user.created_at).to be_a Time
      expect(user.created_at).to be_utc
    end
    it 'returns nil when created_at is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.created_at).to be_nil
    end
  end

  describe '#created?' do
    it 'returns true when created_at is set' do
      user = Twitter::User.new(id: 7_505_382, created_at: 'Mon Jul 16 12:59:01 +0000 2007')
      expect(user.created?).to be true
    end
    it 'returns false when created_at is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.created?).to be false
    end
  end

  describe '#description_uris' do
    it 'returns an array of Entity::URIs when description URI entities are set' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [10, 33],
        },
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})
      expect(user.description_uris).to be_an Array
      expect(user.description_uris.first).to be_a Twitter::Entity::URI
      expect(user.description_uris.first.indices).to eq([10, 33])
      expect(user.description_uris.first.expanded_uri).to be_an Addressable::URI
    end
    it 'is empty when not set' do
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: []}})
      expect(user.description_uris).to be_empty
    end
  end

  describe '#description_uris?' do
    it 'returns true when the tweet includes description URI entities' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [10, 33],
        },
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})
      expect(user.description_uris?).to be true
    end
    it 'returns false when no entities are present' do
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: []}})
      expect(user.description_uris?).to be false
    end
  end

  describe '#entities?' do
    it 'returns true if there are entities set' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [10, 33],
        },
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})
      expect(user.entities?).to be true
    end
    it 'returns false if there are blank lists of entities set' do
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: []}})
      expect(user.entities?).to be false
    end
    it 'returns false if there are no entities set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.entities?).to be false
    end
  end

  describe '#profile_background_image_uri' do
    it 'returns the URI to the user' do
      user = Twitter::User.new(id: 7_505_382, profile_background_image_url: 'http://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png')
      expect(user.profile_background_image_uri).to be_an Addressable::URI
      expect(user.profile_background_image_uri.to_s).to eq('http://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png')
    end
    it 'returns nil when the screen name is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_background_image_uri).to be_nil
    end
  end

  describe '#profile_background_image_uri_https' do
    it 'returns the URI to the user' do
      user = Twitter::User.new(id: 7_505_382, profile_background_image_url_https: 'https://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png')
      expect(user.profile_background_image_uri_https).to be_an Addressable::URI
      expect(user.profile_background_image_uri_https.to_s).to eq('https://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png')
    end
    it 'returns nil when the screen name is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_background_image_uri_https).to be_nil
    end
  end

  describe '#profile_banner_uri' do
    it 'accepts utf8 urls' do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581©_normal.png')
      expect(user.profile_banner_uri).to be_an Addressable::URI
    end
    it 'returns a URI when profile_banner_url is set' do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
      expect(user.profile_banner_uri).to be_an Addressable::URI
    end
    it 'returns nil when profile_banner_uri is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_banner_uri).to be_nil
    end
    it 'returns the web-sized image' do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
      expect(user.profile_banner_uri.to_s).to eq('http://si0.twimg.com/profile_banners/7_505_382/1348266581/web')
    end
    context 'with :web_retina passed' do
      it 'returns the web retina-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri(:web_retina).to_s).to eq('http://si0.twimg.com/profile_banners/7_505_382/1348266581/web_retina')
      end
    end
    context 'with :mobile passed' do
      it 'returns the mobile-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri(:mobile).to_s).to eq('http://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile')
      end
    end
    context 'with :mobile_retina passed' do
      it 'returns the mobile retina-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri(:mobile_retina).to_s).to eq('http://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile_retina')
      end
    end
    context 'with :ipad passed' do
      it 'returns the mobile-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri(:ipad).to_s).to eq('http://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad')
      end
    end
    context 'with :ipad_retina passed' do
      it 'returns the mobile retina-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri(:ipad_retina).to_s).to eq('http://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad_retina')
      end
    end
  end

  describe '#profile_banner_uri_https' do
    it 'accepts utf8 urls' do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581©_normal.png')
      expect(user.profile_banner_uri_https).to be_an Addressable::URI
    end
    it 'returns a URI when profile_banner_url is set' do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
      expect(user.profile_banner_uri_https).to be_an Addressable::URI
    end
    it 'returns nil when created_at is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_banner_uri_https).to be_nil
    end
    it 'returns the web-sized image' do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
      expect(user.profile_banner_uri_https.to_s).to eq('https://si0.twimg.com/profile_banners/7_505_382/1348266581/web')
    end
    context 'with :web_retina passed' do
      it 'returns the web retina-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri_https(:web_retina).to_s).to eq('https://si0.twimg.com/profile_banners/7_505_382/1348266581/web_retina')
      end
    end
    context 'with :mobile passed' do
      it 'returns the mobile-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri_https(:mobile).to_s).to eq('https://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile')
      end
    end
    context 'with :mobile_retina passed' do
      it 'returns the mobile retina-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri_https(:mobile_retina).to_s).to eq('https://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile_retina')
      end
    end
    context 'with :ipad passed' do
      it 'returns the mobile-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri_https(:ipad).to_s).to eq('https://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad')
      end
    end
    context 'with :ipad_retina passed' do
      it 'returns the mobile retina-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
        expect(user.profile_banner_uri_https(:ipad_retina).to_s).to eq('https://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad_retina')
      end
    end
  end

  describe '#profile_banner_uri?' do
    it 'returns true when profile_banner_url is set' do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
      expect(user.profile_banner_uri?).to be true
    end
    it 'returns false when profile_banner_url is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_banner_uri?).to be false
    end
  end

  describe '#profile_image_uri' do
    it 'accepts utf8 urls' do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://si0.twimg.com/profile_images/7_505_382/1348266581©_normal.png')
      expect(user.profile_image_uri).to be_an Addressable::URI
    end
    it 'returns a URI when profile_image_url_https is set' do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
      expect(user.profile_image_uri).to be_an Addressable::URI
    end
    it 'returns nil when created_at is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_image_uri).to be_nil
    end
    it 'returns the normal-sized image' do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
      expect(user.profile_image_uri.to_s).to eq('http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
    end
    context 'with :original passed' do
      it 'returns the original image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
        expect(user.profile_image_uri(:original).to_s).to eq('http://a0.twimg.com/profile_images/1759857427/image1326743606.png')
      end
    end
    context 'with :bigger passed' do
      it 'returns the bigger-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
        expect(user.profile_image_uri(:bigger).to_s).to eq('http://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png')
      end
    end
    context 'with :mini passed' do
      it 'returns the mini-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
        expect(user.profile_image_uri(:mini).to_s).to eq('http://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png')
      end
    end
    context 'with capitalized file extension' do
      it 'returns the correct image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://si0.twimg.com/profile_images/67759670/DSCN2136_normal.JPG')
        expect(user.profile_image_uri(:original).to_s).to eq('http://si0.twimg.com/profile_images/67759670/DSCN2136.JPG')
        expect(user.profile_image_uri(:bigger).to_s).to eq('http://si0.twimg.com/profile_images/67759670/DSCN2136_bigger.JPG')
        expect(user.profile_image_uri(:mini).to_s).to eq('http://si0.twimg.com/profile_images/67759670/DSCN2136_mini.JPG')
      end
    end
  end

  describe '#profile_image_uri_https' do
    it 'accepts utf8 urls' do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://si0.twimg.com/profile_images/7_505_382/1348266581©_normal.png')
      expect(user.profile_image_uri_https).to be_an Addressable::URI
    end
    it 'returns a URI when profile_image_url_https is set' do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
      expect(user.profile_image_uri_https).to be_an Addressable::URI
    end
    it 'returns nil when created_at is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_image_uri_https).to be_nil
    end
    it 'returns the normal-sized image' do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
      expect(user.profile_image_uri_https.to_s).to eq('https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
    end
    context 'with :original passed' do
      it 'returns the original image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
        expect(user.profile_image_uri_https(:original).to_s).to eq('https://a0.twimg.com/profile_images/1759857427/image1326743606.png')
      end
    end
    context 'with :bigger passed' do
      it 'returns the bigger-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
        expect(user.profile_image_uri_https(:bigger).to_s).to eq('https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png')
      end
    end
    context 'with :mini passed' do
      it 'returns the mini-sized image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png')
        expect(user.profile_image_uri_https(:mini).to_s).to eq('https://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png')
      end
    end
    context 'with capitalized file extension' do
      it 'returns the correct image' do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://si0.twimg.com/profile_images/67759670/DSCN2136_normal.JPG')
        expect(user.profile_image_uri_https(:original).to_s).to eq('https://si0.twimg.com/profile_images/67759670/DSCN2136.JPG')
        expect(user.profile_image_uri_https(:bigger).to_s).to eq('https://si0.twimg.com/profile_images/67759670/DSCN2136_bigger.JPG')
        expect(user.profile_image_uri_https(:mini).to_s).to eq('https://si0.twimg.com/profile_images/67759670/DSCN2136_mini.JPG')
      end
    end
  end

  describe '#profile_image_uri?' do
    it 'returns true when profile_image_url_https is set' do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: 'https://si0.twimg.com/profile_banners/7_505_382/1348266581')
      expect(user.profile_image_uri?).to be true
    end
    it 'returns false when profile_image_url_https is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.profile_image_uri?).to be false
    end
  end

  describe '#status' do
    it 'returns a Status when status is set' do
      user = Twitter::User.new(id: 7_505_382, status: {id: 540_897_316_908_331_009})
      expect(user.status).to be_a Twitter::Tweet
    end
    it 'returns nil when status is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.status).to be_nil
    end
    it 'has a user' do
      user = Twitter::User.new(id: 7_505_382, status: {id: 540_897_316_908_331_009})
      expect(user.status.user).to be_a Twitter::User
      expect(user.status.user.id).to eq(7_505_382)
    end
  end

  describe '#status?' do
    it 'returns true when status is set' do
      user = Twitter::User.new(id: 7_505_382, status: {id: 540_897_316_908_331_009})
      expect(user.status?).to be true
    end
    it 'returns false when status is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.status?).to be false
    end
  end

  describe '#uri' do
    it 'returns the URI to the user' do
      user = Twitter::User.new(id: 7_505_382, screen_name: 'sferik')
      expect(user.uri).to be_an Addressable::URI
      expect(user.uri.to_s).to eq('https://twitter.com/sferik')
    end
    it 'returns nil when the screen name is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.uri).to be_nil
    end
  end

  describe '#website' do
    it 'returns a URI when the url is set' do
      user = Twitter::User.new(id: 7_505_382, url: 'https://github.com/sferik')
      expect(user.website).to be_an Addressable::URI
      expect(user.website.to_s).to eq('https://github.com/sferik')
    end
    it 'returns a URI when the tweet includes website URI entities' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [0, 23],
        },
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})
      expect(user.website).to be_an Addressable::URI
      expect(user.website.to_s).to eq('http://example.com/expanded')
    end
    it 'returns nil when the url is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.website).to be_nil
    end
  end

  describe '#website?' do
    it 'returns true when the url is set' do
      user = Twitter::User.new(id: 7_505_382, url: 'https://github.com/sferik')
      expect(user.website?).to be true
    end
    it 'returns true when the tweet includes website URI entities' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [0, 23],
        },
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})
      expect(user.website?).to be true
    end
    it 'returns false when the url is not set' do
      user = Twitter::User.new(id: 7_505_382)
      expect(user.website?).to be false
    end
  end

  describe '#website_uris' do
    it 'returns an array of Entity::URIs when website URI entities are set' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [0, 23],
        },
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})
      expect(user.website_uris).to be_an Array
      expect(user.website_uris.first).to be_a Twitter::Entity::URI
      expect(user.website_uris.first.indices).to eq([0, 23])
      expect(user.website_uris.first.expanded_uri).to be_an Addressable::URI
    end
    it 'is empty when not set' do
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: []}})
      expect(user.website_uris).to be_empty
    end
  end

  describe '#website_uris?' do
    it 'returns true when the tweet includes website URI entities' do
      urls_array = [
        {
          url: 'https://t.co/L2xIBazMPf',
          expanded_url: 'http://example.com/expanded',
          display_url: 'example.com/expanded...',
          indices: [0, 23],
        },
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})
      expect(user.website_uris?).to be true
    end
    it 'returns false when no entities are present' do
      user = Twitter::User.new(id: 7_505_382, entities: {})
      expect(user.website_uris?).to be false
    end
  end
end
