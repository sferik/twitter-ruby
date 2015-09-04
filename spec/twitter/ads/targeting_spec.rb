require 'helper'

describe Twitter::Ads::Targeting do
  let(:account) { "hkk5" }
  let(:line_item) { "69ob" }
  before do
    @client = Twitter::Ads::Client.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS')
  end

  describe '#targeting_criteria' do
    before do
      stub_get("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria").with(query: {line_item_id: line_item})
        .to_return(body: fixture('targeting_criteria.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.targeting_criteria(account, line_item)
      expect(a_get("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria").with(query: {line_item_id: line_item})).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.targeting_criteria(account, line_item)
      expect(criteria.map(&:id)).to match(['2kzxf', '2kzxi', '2kzxj', '2mq7j'])
    end
  end

  describe '#targeting_criterion' do
    before do
      stub_get("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria/2rqqn")
        .to_return(body: fixture('targeting_criterion_get.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resource' do
      @client.targeting_criterion(account, '2rqqn')
      expect(a_get("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria/2rqqn")).to have_been_made
    end
    it 'gets the correct resource' do
      criterion = @client.targeting_criterion(account, '2rqqn')
      expect(criterion.id).to eq('2rqqn')
    end
  end

  describe '#create_targeting_criterion' do
    let(:args) do
      {
        targeting_type: 'PHRASE_KEYWORD',
        targeting_value: 'righteous dude',
        line_item_id: line_item,
      }
    end
    before do
      stub_post("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria")
        .with(body: args).to_return(body: fixture('targeting_criterion_create.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'creates a targeting criterion' do
      criterion = @client.create_targeting_criterion(account, line_item, 'PHRASE_KEYWORD', 'righteous dude')
      expect(a_post("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria").with(body: args)).to have_been_made
      expect(criterion).to be_a(Twitter::TargetingCriterion)
      expect(criterion.id).to eq('31umv7')
    end
  end

  describe '#update_targeting_criteria' do
    let(:args) do
      {
        broad_keywords: 'snowboarding',
        locations: '3376992a082d67c7',
        gender: '1',
      }
    end
    let(:expected) { args.merge(line_item_id: '6zva') }
    before do
      stub_put("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria")
        .with(body: expected).to_return(body: fixture('targeting_criterion_put.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'updates the resource' do
      criteria = @client.update_targeting_criteria(account, '6zva', args)
      expect(a_put("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria").with(body: expected)).to have_been_made
      expect(criteria.map(&:id)).to match(['ziujs', 'ziujt', 'ziuju'])
    end
  end

  describe '#destroy_targeting_criterion' do
    before do
      stub_delete("https://ads-api.twitter.com/0/accounts/#{account}/targeting_criteria/43852jv8hlet")
        .to_return(body: fixture('targeting_criterion_delete.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'deletes the requested resource' do
      criterion = @client.destroy_targeting_criterion(account, '43852jv8hlet')
      expect(criterion).to be_a(Twitter::TargetingCriterion)
      expect(criterion.id).to eq('43852jv8hlet')
      expect(criterion).to be_deleted
    end
  end

  describe '#targeting_suggestions' do
    let(:args) do
      {
        suggestion_type: 'KEYWORD',
        targeting_values: 'cats',
      }
    end
    before do
      stub_get("https://ads-api.twitter.com/0/accounts/abcd/targeting_suggestions")
        .with(query: args).to_return(body: fixture('targeting_suggestions.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests targeting values' do
      @client.targeting_suggestions('abcd', 'KEYWORD', 'cats')
      expect(a_get("https://ads-api.twitter.com/0/accounts/abcd/targeting_suggestions").with(query: args)).to have_been_made
    end
    it 'gets the correct suggestions' do
      suggestions = @client.targeting_suggestions('abcd', 'KEYWORD', 'cats')
      expect(suggestions).to be_a(Array)
      expect(suggestions.first).to be_a(Twitter::TargetingSuggestion)
      expect(suggestions.map(&:suggestion_value)).to include('hairless', 'pugs', 'kittens')
    end
  end

  describe '#app_store_categories' do
    let(:args) { {q: 'music', store: 'IOS_APP_STORE'} }
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/app_store_categories').with(query: args)
        .to_return(body: fixture('app_store_categories.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.app_store_categories(args)
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/app_store_categories').with(query: args)).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.app_store_categories(args)
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::AppStoreCategory)
      expect(criteria.map(&:targeting_value)).to match(['i', 'u'])
    end
  end

  describe '#behavior_taxonomies' do
    let(:args) { {parent_behavior_taxonomy_ids: 'null'} }
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/behavior_taxonomies').with(query: args)
        .to_return(body: fixture('behavior_taxonomies.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.behavior_taxonomies(args)
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/behavior_taxonomies').with(query: args)).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.behavior_taxonomies(args)
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::BehaviorTaxonomy)
      expect(criteria.map(&:id)).to match(['1', '4', 'd', 'x', '1d', '1i', '1m', '1o', '2x', '30'])
    end
  end

  describe '#behaviors' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/behaviors')
        .to_return(body: fixture('behaviors.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.behaviors
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/behaviors')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.behaviors
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::Behavior)
      expect(criteria.map(&:id)).to match(['lfmj', 'lfrr'])
    end
  end

  describe '#devices' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/devices')
        .to_return(body: fixture('devices.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.devices
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/devices')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.devices
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::Device)
      expect(criteria.map(&:targeting_value)).to match(['44', '45', '46', '47'])
    end
  end

  describe '#interests' do
    let(:args) { {q: 'pets'} }
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/interests').with(query: args)
        .to_return(body: fixture('interests.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.interests(args)
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/interests').with(query: args)).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.interests(args)
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::Interest)
      expect(criteria.map(&:targeting_value)).to match(['19001', '19002', '19003', '19004', '19005', '19006'])
    end
  end

  describe '#languages' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/languages')
        .to_return(body: fixture('ad_languages.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.languages
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/languages')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.languages
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::Language)
      expect(criteria.map(&:targeting_value)).to match(['ar', 'zh', 'nl', 'en', 'fa', 'fi', 'fr', 'hi', 'id', 'it', 'ja', 'ko', 'no', 'pl', 'pt', 'ru', 'es', 'sv', 'th', 'tr'])
    end
  end

  describe '#locations' do
    let(:args) { {location_type: 'CITY', q: 'Portland'} }
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/locations').with(query: args)
        .to_return(body: fixture('ad_locations.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.locations(args)
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/locations').with(query: args)).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.locations(args)
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::Location)
      expect(criteria.map(&:targeting_value)).to match(['b6b8d75a320f81d9', '00a8b25e420adc94', '00638a3c43eadcf3', '6c6fd550ac2d3d60'])
    end
  end

  describe '#network_operators' do
    let(:args) { {country_code: 'US', count: 5} }
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/network_operators').with(query: args)
        .to_return(body: fixture('network_operators.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.network_operators(args)
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/network_operators').with(query: args)).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.network_operators(args)
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::NetworkOperator)
      expect(criteria.map(&:targeting_value)).to match(['2l', '1b', '2t', '14', '1i'])
    end
  end

  describe '#platform_versions' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/platform_versions')
        .to_return(body: fixture('platform_versions.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.platform_versions
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/platform_versions')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.platform_versions
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::PlatformVersion)
      expect(criteria.map(&:targeting_value)).to match(['17', '18'])
    end
  end

  describe '#platforms' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/platforms')
        .to_return(body: fixture('platforms.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.platforms
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/platforms')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.platforms
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::Platform)
      expect(criteria.map(&:targeting_value)).to match(['0', '1', '2', '3', '4'])
    end
  end

  describe 'tv_channels' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/tv_channels')
        .to_return(body: fixture('tv_channels.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.tv_channels
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/tv_channels')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.tv_channels
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::TVChannel)
      expect(criteria.map(&:id)).to match(['3351', '3352', '3353', '3354', '3356', '3358', '3360', '3362', '3363', '3365', '3366', '3453'])
    end
  end

  describe 'tv_genres' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/tv_genres')
        .to_return(body: fixture('tv_genres.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.tv_genres
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/tv_genres')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.tv_genres
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::TVGenre)
      expect(criteria.map(&:id)).to match(['2', '11', '6', '4', '16', '1', '14', '18', '19', '12', '8', '3', '15', '21', '10', '13', '9', '7', '5', '17'])
    end
  end

  describe 'tv_markets' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/tv_markets')
        .to_return(body: fixture('tv_markets.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.tv_markets
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/tv_markets')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.tv_markets
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::TVMarket)
      expect(criteria.map(&:id)).to match(['6', '1', '5', '2', '3', '7', '4'])
    end
  end

  describe 'tv_shows' do
    before do
      stub_get('https://ads-api.twitter.com/0/targeting_criteria/tv_shows')
        .to_return(body: fixture('tv_shows.json'), headers:{content_type: 'application/json; charset=utf-8'})
    end
    it 'requests resources' do
      @client.tv_shows
      expect(a_get('https://ads-api.twitter.com/0/targeting_criteria/tv_shows')).to have_been_made
    end
    it 'gets the right resources' do
      criteria = @client.tv_shows
      expect(criteria.first).to be_a(Twitter::TargetingCriterion::TVShow)
      expect(criteria.map(&:id)).to match([10002546242, 10000283242])
    end
  end
end
