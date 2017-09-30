require 'helper'

describe Twitter::REST::Users do
  before do
    @client = Twitter::REST::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#settings' do
    before do
      stub_get('/1.1/account/settings.json').to_return(body: fixture('settings.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_post('/1.1/account/settings.json').with(body: {trend_location_woeid: '23424803'}).to_return(body: fixture('settings.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource on GET' do
      @client.settings
      expect(a_get('/1.1/account/settings.json')).to have_been_made
    end
    it 'returns settings' do
      settings = @client.settings
      expect(settings).to be_a Twitter::Settings
      expect(settings.language).to eq('en')
    end
    it 'requests the correct resource on POST' do
      @client.settings(trend_location_woeid: '23424803')
      expect(a_post('/1.1/account/settings.json').with(body: {trend_location_woeid: '23424803'})).to have_been_made
    end
    it 'returns settings' do
      settings = @client.settings(trend_location_woeid: '23424803')
      expect(settings).to be_a Twitter::Settings
      expect(settings.language).to eq('en')
    end
  end

  describe '#verify_credentials' do
    before do
      stub_get('/1.1/account/verify_credentials.json').to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.verify_credentials
      expect(a_get('/1.1/account/verify_credentials.json')).to have_been_made
    end
    it 'returns the requesting user' do
      user = @client.verify_credentials
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end
  end

  describe '#update_delivery_device' do
    before do
      stub_post('/1.1/account/update_delivery_device.json').with(body: {device: 'sms'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.update_delivery_device('sms')
      expect(a_post('/1.1/account/update_delivery_device.json').with(body: {device: 'sms'})).to have_been_made
    end
    it 'returns a user' do
      user = @client.update_delivery_device('sms')
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end
  end

  describe '#update_profile' do
    before do
      stub_post('/1.1/account/update_profile.json').with(body: {url: 'http://github.com/sferik/'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.update_profile(url: 'http://github.com/sferik/')
      expect(a_post('/1.1/account/update_profile.json').with(body: {url: 'http://github.com/sferik/'})).to have_been_made
    end
    it 'returns a user' do
      user = @client.update_profile(url: 'http://github.com/sferik/')
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end
  end

  describe '#update_profile_background_image' do
    before do
      stub_post('/1.1/account/update_profile_background_image.json').to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.update_profile_background_image(fixture('we_concept_bg2.png'))
      expect(a_post('/1.1/account/update_profile_background_image.json')).to have_been_made
    end
    it 'returns a user' do
      user = @client.update_profile_background_image(fixture('we_concept_bg2.png'))
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end
  end

  describe '#update_profile_image' do
    before do
      stub_post('/1.1/account/update_profile_image.json').to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.update_profile_image(fixture('me.jpeg'))
      expect(a_post('/1.1/account/update_profile_image.json')).to have_been_made
    end
    it 'returns a user' do
      user = @client.update_profile_image(fixture('me.jpeg'))
      expect(user).to be_a Twitter::User
      expect(user.id).to eq(7_505_382)
    end
  end

  describe '#suggestions' do
    context 'with a category slug passed' do
      before do
        stub_get('/1.1/users/suggestions/art-design.json').to_return(body: fixture('category.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.suggestions('art-design')
        expect(a_get('/1.1/users/suggestions/art-design.json')).to have_been_made
      end
      it 'returns the users in a given category of the Twitter suggested user list' do
        suggestion = @client.suggestions('art-design')
        expect(suggestion).to be_a Twitter::Suggestion
        expect(suggestion.name).to eq('Art & Design')
        expect(suggestion.users).to be_an Array
        expect(suggestion.users.first).to be_a Twitter::User
      end
    end
    context 'without arguments passed' do
      before do
        stub_get('/1.1/users/suggestions.json').to_return(body: fixture('suggestions.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.suggestions
        expect(a_get('/1.1/users/suggestions.json')).to have_been_made
      end
      it 'returns the list of suggested user categories' do
        suggestions = @client.suggestions
        expect(suggestions).to be_an Array
        expect(suggestions.first).to be_a Twitter::Suggestion
        expect(suggestions.first.name).to eq('Art & Design')
      end
    end
  end

  describe '#suggest_users' do
    before do
      stub_get('/1.1/users/suggestions/art-design/members.json').to_return(body: fixture('members.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.suggest_users('art-design')
      expect(a_get('/1.1/users/suggestions/art-design/members.json')).to have_been_made
    end
    it 'returns users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user' do
      suggest_users = @client.suggest_users('art-design')
      expect(suggest_users).to be_an Array
      expect(suggest_users.first).to be_a Twitter::User
      expect(suggest_users.first.id).to eq(13)
    end
  end

  describe '#blocked' do
    before do
      stub_get('/1.1/blocks/list.json').with(query: {cursor: '-1'}).to_return(body: fixture('users_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.blocked
      expect(a_get('/1.1/blocks/list.json').with(query: {cursor: '-1'})).to have_been_made
    end
    it 'returns an array of user objects that the authenticating user is blocking' do
      blocked = @client.blocked
      expect(blocked).to be_a Twitter::Cursor
      expect(blocked.first).to be_a Twitter::User
      expect(blocked.first.id).to eq(7_505_382)
    end
    context 'with each' do
      before do
        stub_get('/1.1/blocks/list.json').with(query: {cursor: '1322801608223717003'}).to_return(body: fixture('users_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.blocked.each {}
        expect(a_get('/1.1/blocks/list.json').with(query: {cursor: '-1'})).to have_been_made
        expect(a_get('/1.1/blocks/list.json').with(query: {cursor: '1322801608223717003'})).to have_been_made
      end
    end
  end

  describe '#blocked_ids' do
    before do
      stub_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'}).to_return(body: fixture('ids_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.blocked_ids
      expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'})).to have_been_made
    end
    it 'returns an array of numeric user IDs the authenticating user is blocking' do
      blocked_ids = @client.blocked_ids
      expect(blocked_ids).to be_a Twitter::Cursor
      expect(blocked_ids.first).to eq(20_009_713)
    end
    context 'with each' do
      before do
        stub_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'}).to_return(body: fixture('ids_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.blocked_ids.each {}
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'})).to have_been_made
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'})).to have_been_made
      end
    end
  end

  describe '#block?' do
    context 'with a screen name passed' do
      before do
        stub_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'}).to_return(body: fixture('ids_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'}).to_return(body: fixture('ids_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/users/show.json').with(query: {screen_name: 'pengwynn'}).to_return(body: fixture('pengwynn.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/users/show.json').with(query: {screen_name: 'sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.block?('sferik')
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'})).to have_been_made
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'})).to have_been_made
        expect(a_get('/1.1/users/show.json').with(query: {screen_name: 'sferik'})).to have_been_made
      end
      it 'returns true if block exists' do
        block = @client.block?('pengwynn')
        expect(block).to be true
      end
      it 'returns false if block does not exist' do
        block = @client.block?('sferik')
        expect(block).to be false
      end
    end
    context 'with a user ID passed' do
      before do
        stub_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'}).to_return(body: fixture('ids_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'}).to_return(body: fixture('ids_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resources' do
        @client.block?(7_505_382)
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'})).to have_been_made
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'})).to have_been_made
      end
    end
    context 'with a user object passed' do
      before do
        stub_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'}).to_return(body: fixture('ids_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'}).to_return(body: fixture('ids_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resources' do
        user = Twitter::User.new(id: '7505382')
        @client.block?(user)
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '-1'})).to have_been_made
        expect(a_get('/1.1/blocks/ids.json').with(query: {cursor: '1305102810874389703'})).to have_been_made
      end
    end
  end

  describe '#block' do
    before do
      stub_post('/1.1/blocks/create.json').with(body: {screen_name: 'sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.block('sferik')
      expect(a_post('/1.1/blocks/create.json')).to have_been_made
    end
    it 'returns an array of blocked users' do
      users = @client.block('sferik')
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe '#unblock' do
    before do
      stub_post('/1.1/blocks/destroy.json').with(body: {screen_name: 'sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.unblock('sferik')
      expect(a_post('/1.1/blocks/destroy.json').with(body: {screen_name: 'sferik'})).to have_been_made
    end
    it 'returns an array of un-blocked users' do
      users = @client.unblock('sferik')
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe '#users' do
    context 'with screen names passed' do
      before do
        stub_get('/1.1/users/lookup.json').with(query: {screen_name: 'sferik,pengwynn'}).to_return(body: fixture('users.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.users('sferik', 'pengwynn')
        expect(a_get('/1.1/users/lookup.json').with(query: {screen_name: 'sferik,pengwynn'})).to have_been_made
      end
      it 'returns up to 100 users worth of extended information' do
        users = @client.users('sferik', 'pengwynn')
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq(7_505_382)
      end
      context 'with URI objects passed' do
        it 'requests the correct resource' do
          sferik = URI.parse('https://twitter.com/sferik')
          pengwynn = URI.parse('https://twitter.com/pengwynn')
          @client.users(sferik, pengwynn)
          expect(a_get('/1.1/users/lookup.json').with(query: {screen_name: 'sferik,pengwynn'})).to have_been_made
        end
      end
    end
    context 'with numeric screen names passed' do
      before do
        stub_get('/1.1/users/lookup.json').with(query: {screen_name: '0,311'}).to_return(body: fixture('users.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.users('0', '311')
        expect(a_get('/1.1/users/lookup.json').with(query: {screen_name: '0,311'})).to have_been_made
      end
    end
    context 'with user IDs passed' do
      before do
        stub_get('/1.1/users/lookup.json').with(query: {user_id: '7505382,14100886'}).to_return(body: fixture('users.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.users(7_505_382, 14_100_886)
        expect(a_get('/1.1/users/lookup.json').with(query: {user_id: '7505382,14100886'})).to have_been_made
      end
    end
    context 'with both screen names and user IDs passed' do
      before do
        stub_get('/1.1/users/lookup.json').with(query: {screen_name: 'sferik', user_id: '14100886'}).to_return(body: fixture('users.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.users('sferik', 14_100_886)
        expect(a_get('/1.1/users/lookup.json').with(query: {screen_name: 'sferik', user_id: '14100886'})).to have_been_made
      end
    end
    context 'with user objects passed' do
      before do
        stub_get('/1.1/users/lookup.json').with(query: {user_id: '7505382,14100886'}).to_return(body: fixture('users.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        user1 = Twitter::User.new(id: 7_505_382)
        user2 = Twitter::User.new(id: 14_100_886)
        @client.users(user1, user2)
        expect(a_get('/1.1/users/lookup.json').with(query: {user_id: '7505382,14100886'})).to have_been_made
      end
    end
  end

  describe '#user' do
    context 'with a screen name passed' do
      before do
        stub_get('/1.1/users/show.json').with(query: {screen_name: 'sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.user('sferik')
        expect(a_get('/1.1/users/show.json').with(query: {screen_name: 'sferik'})).to have_been_made
      end
      it 'returns extended information of a given user' do
        user = @client.user('sferik')
        expect(user).to be_a Twitter::User
        expect(user.id).to eq(7_505_382)
      end
    end
    context 'with a screen name including "@" passed' do
      before do
        stub_get('/1.1/users/show.json').with(query: {screen_name: '@sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.user('@sferik')
        expect(a_get('/1.1/users/show.json').with(query: {screen_name: '@sferik'})).to have_been_made
      end
    end
    context 'with a numeric screen name passed' do
      before do
        stub_get('/1.1/users/show.json').with(query: {screen_name: '0'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.user('0')
        expect(a_get('/1.1/users/show.json').with(query: {screen_name: '0'})).to have_been_made
      end
    end
    context 'with a user ID passed' do
      before do
        stub_get('/1.1/users/show.json').with(query: {user_id: '7505382'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.user(7_505_382)
        expect(a_get('/1.1/users/show.json').with(query: {user_id: '7505382'})).to have_been_made
      end
    end
    context 'with a user object passed' do
      before do
        stub_get('/1.1/users/show.json').with(query: {user_id: '7505382'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        user = Twitter::User.new(id: 7_505_382)
        @client.user(user)
        expect(a_get('/1.1/users/show.json').with(query: {user_id: '7505382'})).to have_been_made
      end
    end
  end
  context 'without a screen name or user ID passed' do
    context 'without options passed' do
      before do
        stub_get('/1.1/account/verify_credentials.json').to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.user
        expect(a_get('/1.1/account/verify_credentials.json')).to have_been_made
      end
    end
    context 'with options passed' do
      before do
        stub_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.user(skip_status: true)
        expect(a_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'})).to have_been_made
      end
    end
  end

  describe '#user?' do
    before do
      stub_get('/1.1/users/show.json').with(query: {screen_name: 'sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_get('/1.1/users/show.json').with(query: {screen_name: 'pengwynn'}).to_return(body: fixture('not_found.json'), status: 404, headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.user?('sferik')
      expect(a_get('/1.1/users/show.json').with(query: {screen_name: 'sferik'})).to have_been_made
    end
    it 'returns true if user exists' do
      user = @client.user?('sferik')
      expect(user).to be true
    end
    it 'returns false if user does not exist' do
      user = @client.user?('pengwynn')
      expect(user).to be false
    end
  end

  describe '#user_search' do
    before do
      stub_get('/1.1/users/search.json').with(query: {q: 'Erik Michaels-Ober'}).to_return(body: fixture('user_search.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.user_search('Erik Michaels-Ober')
      expect(a_get('/1.1/users/search.json').with(query: {q: 'Erik Michaels-Ober'})).to have_been_made
    end
    it 'returns an array of user search results' do
      user_search = @client.user_search('Erik Michaels-Ober')
      expect(user_search).to be_an Array
      expect(user_search.first).to be_a Twitter::User
      expect(user_search.first.id).to eq(7_505_382)
    end
  end

  describe '#contributees' do
    context 'with a screen name passed' do
      before do
        stub_get('/1.1/users/contributees.json').with(query: {screen_name: 'sferik'}).to_return(body: fixture('contributees.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.contributees('sferik')
        expect(a_get('/1.1/users/contributees.json').with(query: {screen_name: 'sferik'})).to have_been_made
      end
      it 'returns contributees' do
        contributees = @client.contributees('sferik')
        expect(contributees).to be_an Array
        expect(contributees.first).to be_a Twitter::User
        expect(contributees.first.name).to eq('Twitter API')
      end
    end
    context 'with a user ID passed' do
      before do
        stub_get('/1.1/users/contributees.json').with(query: {user_id: '7505382'}).to_return(body: fixture('contributees.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.contributees(7_505_382)
        expect(a_get('/1.1/users/contributees.json').with(query: {user_id: '7505382'})).to have_been_made
      end
    end
    context 'without arguments passed' do
      before do
        stub_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/users/contributees.json').with(query: {user_id: '7505382'}).to_return(body: fixture('contributees.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.contributees
        expect(a_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'})).to have_been_made
        expect(a_get('/1.1/users/contributees.json').with(query: {user_id: '7505382'})).to have_been_made
      end
      it 'returns contributees' do
        contributees = @client.contributees
        expect(contributees).to be_an Array
        expect(contributees.first).to be_a Twitter::User
        expect(contributees.first.name).to eq('Twitter API')
      end
    end
  end

  describe '#contributors' do
    context 'with a screen name passed' do
      before do
        stub_get('/1.1/users/contributors.json').with(query: {screen_name: 'sferik'}).to_return(body: fixture('members.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.contributors('sferik')
        expect(a_get('/1.1/users/contributors.json').with(query: {screen_name: 'sferik'})).to have_been_made
      end
      it 'returns contributors' do
        contributors = @client.contributors('sferik')
        expect(contributors).to be_an Array
        expect(contributors.first).to be_a Twitter::User
        expect(contributors.first.id).to eq(13)
      end
    end
    context 'with a user ID passed' do
      before do
        stub_get('/1.1/users/contributors.json').with(query: {user_id: '7505382'}).to_return(body: fixture('members.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.contributors(7_505_382)
        expect(a_get('/1.1/users/contributors.json').with(query: {user_id: '7505382'})).to have_been_made
      end
    end
    context 'without arguments passed' do
      before do
        stub_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/users/contributors.json').with(query: {user_id: '7505382'}).to_return(body: fixture('members.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.contributors
        expect(a_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'})).to have_been_made
        expect(a_get('/1.1/users/contributors.json').with(query: {user_id: '7505382'})).to have_been_made
      end
      it 'returns contributors' do
        contributors = @client.contributors
        expect(contributors).to be_an Array
        expect(contributors.first).to be_a Twitter::User
        expect(contributors.first.id).to eq(13)
      end
    end
  end

  describe '#remove_profile_banner' do
    before do
      stub_post('/1.1/account/remove_profile_banner.json').to_return(body: '{}', headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.remove_profile_banner
      expect(a_post('/1.1/account/remove_profile_banner.json')).to have_been_made
    end
    it 'returns a user' do
      response = @client.remove_profile_banner
      expect(response).to be true
    end
  end

  describe '#update_profile_banner' do
    before do
      stub_post('/1.1/account/update_profile_banner.json').to_return(body: '{}', headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.update_profile_banner(fixture('me.jpeg'))
      expect(a_post('/1.1/account/update_profile_banner.json')).to have_been_made
    end
    it 'returns a user' do
      response = @client.update_profile_banner(fixture('me.jpeg'))
      expect(response).to be true
    end
  end

  describe '#profile_banner' do
    context 'with a screen_name passed' do
      before do
        stub_get('/1.1/users/profile_banner.json').with(query: {screen_name: 'sferik'}).to_return(body: fixture('profile_banner.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.profile_banner('sferik')
        expect(a_get('/1.1/users/profile_banner.json').with(query: {screen_name: 'sferik'})).to have_been_made
      end
      it 'returns a profile banner' do
        banner = @client.profile_banner('sferik')
        expect(banner).to be_a Twitter::ProfileBanner
        expect(banner.sizes).to be_a Hash
        expect(banner.sizes[:mobile].height).to eq(160)
      end
    end
    context 'with a user ID passed' do
      before do
        stub_get('/1.1/users/profile_banner.json').with(query: {user_id: '7505382'}).to_return(body: fixture('profile_banner.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.profile_banner(7_505_382)
        expect(a_get('/1.1/users/profile_banner.json').with(query: {user_id: '7505382'})).to have_been_made
      end
    end
    context 'without arguments passed' do
      before do
        stub_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
        stub_get('/1.1/users/profile_banner.json').with(query: {user_id: '7505382'}).to_return(body: fixture('profile_banner.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.profile_banner
        expect(a_get('/1.1/account/verify_credentials.json').with(query: {skip_status: 'true'})).to have_been_made
        expect(a_get('/1.1/users/profile_banner.json').with(query: {user_id: '7505382'})).to have_been_made
      end
      it 'returns an array of numeric IDs for every user following the specified user' do
        banner = @client.profile_banner
        expect(banner).to be_a Twitter::ProfileBanner
        expect(banner.sizes).to be_a Hash
        expect(banner.sizes[:mobile].height).to eq(160)
      end
    end
  end

  describe '#mute' do
    before do
      stub_post('/1.1/mutes/users/create.json').with(body: {screen_name: 'sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.mute('sferik')
      expect(a_post('/1.1/mutes/users/create.json')).to have_been_made
    end
    it 'returns an array of muteed users' do
      users = @client.mute('sferik')
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe '#unmute' do
    before do
      stub_post('/1.1/mutes/users/destroy.json').with(body: {screen_name: 'sferik'}).to_return(body: fixture('sferik.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.unmute('sferik')
      expect(a_post('/1.1/mutes/users/destroy.json').with(body: {screen_name: 'sferik'})).to have_been_made
    end
    it 'returns an array of un-muteed users' do
      users = @client.unmute('sferik')
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq(7_505_382)
    end
  end

  describe '#muted' do
    before do
      stub_get('/1.1/mutes/users/list.json').with(query: {cursor: '-1'}).to_return(body: fixture('users_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.muted
      expect(a_get('/1.1/mutes/users/list.json').with(query: {cursor: '-1'})).to have_been_made
    end
    it 'returns an array of user objects that the authenticating user is muting' do
      muted = @client.muted
      expect(muted).to be_a Twitter::Cursor
      expect(muted.first).to be_a Twitter::User
      expect(muted.first.id).to eq(7_505_382)
    end
    context 'with each' do
      before do
        stub_get('/1.1/mutes/users/list.json').with(query: {cursor: '1322801608223717003'}).to_return(body: fixture('users_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.muted.each {}
        expect(a_get('/1.1/mutes/users/list.json').with(query: {cursor: '-1'})).to have_been_made
        expect(a_get('/1.1/mutes/users/list.json').with(query: {cursor: '1322801608223717003'})).to have_been_made
      end
    end
  end

  describe '#muted_ids' do
    before do
      stub_get('/1.1/mutes/users/ids.json').with(query: {cursor: '-1'}).to_return(body: fixture('ids_list.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.muted_ids
      expect(a_get('/1.1/mutes/users/ids.json').with(query: {cursor: '-1'})).to have_been_made
    end
    it 'returns an array of numeric user IDs the authenticating user is muting' do
      muted_ids = @client.muted_ids
      expect(muted_ids).to be_a Twitter::Cursor
      expect(muted_ids.first).to eq(20_009_713)
    end
    context 'with each' do
      before do
        stub_get('/1.1/mutes/users/ids.json').with(query: {cursor: '1305102810874389703'}).to_return(body: fixture('ids_list2.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.muted_ids.each {}
        expect(a_get('/1.1/mutes/users/ids.json').with(query: {cursor: '-1'})).to have_been_made
        expect(a_get('/1.1/mutes/users/ids.json').with(query: {cursor: '1305102810874389703'})).to have_been_made
      end
    end
  end
end
