require 'helper'

describe Twitter::Streaming::Event do
  let(:first_user) { {
    id: 10_083_602,
    id_str: '10083602',
    name: 'Adam Bird',
    screen_name: 'adambird',
    location: 'Nottingham, UK',
    url: 'http://t.co/M1eaIKDQyz',
    description: 'CEO @onediaryapp, ex @esendex CTO and co-founder, still cycling',
    protected: false,
    followers_count: 1295,
    friends_count: 850,
    listed_count: 53,
    created_at: 'Fri Nov 09 00:35:12 +0000 2007',
    favourites_count: 93,
    utc_offset: 0,
    time_zone: 'London',
    geo_enabled: true,
    verified: false,
    statuses_count: 13_507,
    lang: 'en',
    contributors_enabled: false,
    is_translator: false,
    profile_background_color: 'C0DEED',
    profile_background_image_url: 'http://abs.twimg.com/images/themes/theme1/bg.png',
    profile_bacground_image_url_https: 'https://abs.twimg.com/images/themes/theme1/bg.png',
    profile_background_tile: false,
    profile_image_url: 'http://pbs.twimg.com/profile_images/378800000477232297/23d85bb78f71534eea1e1133fb771f86_normal.jpeg',
    profile_image_url_https: 'https://pbs.twimg.com/profile_images/378800000477232297/23d85bb78f71534eea1e1133fb771f86_normal.jpeg',
    profile_link_color: '0084B4',
    profile_sidebar_border_color: 'C0DEED',
    profile_sidebar_fill_color: 'DDEEF6',
    profile_text_color: '333333',
    profile_use_background_image: true,
    default_profile: true,
    default_profile_image: false,
    following: false,
    follow_request_sent: false,
    notifications: false
  } }

  let(:second_user) { {
    id: 1_292_911_088,
    id_str: '1292911088',
    name: 'One Diary Bot',
    screen_name: 'onediarybot',
    location: nil,
    url: 'http://t.co/etHGc0xHX4',
    description: "I'm the One Diary bot, here to help you with your life including personal cycling weather forecasts.",
    protected: false,
    followers_count: 123,
    friends_count: 157,
    listed_count: 1,
    created_at: 'Sat Mar 23 23:52:18 +0000 2013',
    favourites_count: 0,
    utc_offset: nil,
    time_zone: nil,
    geo_enabled: false,
    verified: false,
    statuses_count: 9637,
    lang: 'en',
    contributors_enabled: false,
    is_translator: false,
    profile_background_color: 'C0DEED',
    profile_background_image_url: 'http://abs.twimg.com/images/themes/theme1/bg.png',
    profile_background_image_url_https: 'https://abs.twimg.com/images/themes/theme1/bg.png',
    profile_background_tile: false,
    profile_image_url: 'http://pbs.twimg.com/profile_images/3651575369/090551d8dd92080198f707769239ff43_normal.jpeg',
    profile_image_url_https: 'https://pbs.twimg.com/profile_images/3651575369/090551d8dd92080198f707769239ff43_normal.jpeg',
    profile_link_color: '0084B4',
    profile_sidebar_border_color: 'C0DEED',
    profile_sidebar_fill_color: 'DDEEF6',
    profile_text_color: '333333',
    profile_use_background_image: true,
    default_profile: true,
    default_profile_image: false,
    following: false,
    follow_request_sent: false,
    notifications: false
  } }

  let(:data) { {
    event: 'follow',
    source: first_user,
    target: second_user
  } }

  subject do
    Twitter::Streaming::Event.new(data)
  end

  context 'when created_at is not set' do
    it { is_expected.to_not be_created }

    describe '#created_at' do
      it { expect(subject.created_at).to be_nil }
    end
  end

  context 'when created_at is set' do
    let(:data) { super().merge(created_at: 'Sun Oct 27 20:44:19 +0000 2013') }

    it { is_expected.to be_created }

    describe '#created_at' do
      it { expect(subject.created_at).to be_a Time }
    end
  end

  describe '#name' do
    it 'returns symbolised version of event string' do
      expect(subject.name).to eq(:follow)
    end
  end

  context 'when target object is not set' do
    describe '#target_object?' do
      it { expect(subject.target_object?).to be false }
    end

    describe '#target_object' do
      it { expect(subject.target_object).to be_a(Twitter::NullObject) }
    end
  end

  context 'when target object is a list' do
    let(:data) { {
      event: 'list_member_added',
      created_at: 'Sun Oct 27 21:05:35 +0000 2013',
      source: first_user,
      target: second_user,
      target_object: {
        id: 60_314_359,
        id_str: '60314359',
        created_at: 'Sun Dec 04 19:54:20 +0000 2011',
        name: 'dev',
        full_name: '@adambird/dev',
        slug: 'dev',
        user: first_user,
        uri: '/adambird/lists/dev',
        description: '',
        following: false,
        mode: 'public',
        subscriber_count: 0,
        member_count: 13
      }
    } }

    describe '#target_object?' do
      it { expect(subject.target_object?).to be true }
    end

    describe '#target_object' do
      it { expect(subject.target_object).to be_a(Twitter::List) }

      describe 'and its full_name' do
        it 'should be the same as in received data' do
          expect(subject.target_object.full_name).to eq('@adambird/dev')
        end
      end
    end
  end

  context 'when target object is a tweet' do
    let(:data) { {
      event: 'favorite',
      created_at: 'Sun Oct 27 21:05:35 +0000 2013',
      source: first_user,
      target: second_user,
      target_object: {
        id: 394_454_214_132_256_768,
        id_str: '394454214132256768',
        created_at: 'Sun Oct 27 13:23:07 +0000 2013',
        user: second_user,
        text: '@darrenliddell my programmers thought that they had that one covered. I have admonished them.',
        in_reply_to_status_id: 394_341_960_603_172_864,
        in_reply_to_status_id_str: '394341960603172864',
        in_reply_to_user_id: 18_845_675,
        in_reply_to_user_id_str: '18845675',
        in_reply_to_screen_name: 'darrenliddell',
        favorited: true,
        contributors: nil,
        coordinates: nil,
        geo: nil,
        place: nil,
        retweet_count: 0,
        retweeted: false,
        source: 'web',
        truncated: false,
        entities: {
          hashtags: [],
          urls: [],
          user_mentions: [
            {
              screen_name: 'darrenliddell',
              id_str: '18845675',
              id: 18_845_675,
              indices: [0, 14],
              name: 'Darren Liddell'
            }
          ]
        }
      }
    } }

    describe '#target_object?' do
      it { expect(subject.target_object?).to be true }
    end

    describe '#target_object' do
      it { expect(subject.target_object).to be_a(Twitter::Tweet) }

      describe 'and its id' do
        it 'should be the same as in received data' do
          expect(subject.target_object.id).to eq(394_454_214_132_256_768)
        end
      end
    end
  end
end
