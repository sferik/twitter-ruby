require 'helper'

describe Twitter::Cursor do

  describe '#each' do
    before do
      @client = Twitter::REST::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS',
                                          :access_token => 'AT', :access_token_secret => 'AS')

      stub_get('/1.1/followers/ids.json').with(:query => {:cursor => '-1', :screen_name => 'sferik'}).to_return(
        :body => fixture('ids_list.json'),
        :headers => {:content_type => 'application/json; charset=utf-8'})

      stub_get('/1.1/followers/ids.json').with(:query => {:cursor => '1305102810874389703', :screen_name => 'sferik'}).to_return(
        :body => fixture('ids_list2.json'),
        :headers => {:content_type => 'application/json; charset=utf-8'})

      stub_get('/1.1/followers/ids.json').with(:query => {:cursor => '-1', :screen_name => 'jack'}).to_return(
        :body => fixture('ids_list.json'),
        :headers => {:content_type => 'application/json; charset=utf-8',
                     'X-Rate-Limit-Limit'     => '15',
                     'X-Rate-Limit-Remaining' => '11',
                     'X-Rate-Limit-Reset'     => Time.now + 10 * 60})

      stub_get('/1.1/followers/ids.json').with(:query => {:cursor => '1305102810874389703', :screen_name => 'jack'}).to_return(
        :body => fixture('ids_list2.json'),
        :headers => {:content_type => 'application/json; charset=utf-8',
                     'X-Rate-Limit-Limit'     => '15',
                     'X-Rate-Limit-Remaining' => '0',
                     'X-Rate-Limit-Reset'     => Time.now + 10 * 60})
    end
    it 'requests the correct resources' do
      @client.follower_ids('sferik').each {}
      expect(a_get('/1.1/followers/ids.json').with(:query => {:cursor => '-1', :screen_name => 'sferik'})).to have_been_made
      expect(a_get('/1.1/followers/ids.json').with(:query => {:cursor => '1305102810874389703', :screen_name => 'sferik'})).to have_been_made
    end
    it 'iterates' do
      count = 0
      @client.follower_ids('sferik').each { count += 1 }
      expect(count).to eq(6)
    end
    context 'with start' do
      it 'iterates' do
        count = 0
        @client.follower_ids('sferik').each(5) { count += 1 }
        expect(count).to eq(1)
      end
    end
    it 'handles the rate limit status' do
      first = @client.follower_ids('jack')
      expect(first.rate_limit).not_to be_nil
      expect(first.rate_limit.remaining).to eq 11
      expect(first.rate_limit.limit).to eq 15
    end
    it 'handles the rate limit status when its not set' do
      first = @client.follower_ids('sferik')
      expect(first.rate_limit).not_to be_nil
      expect(first.rate_limit.remaining).to be_nil
    end
    it 'passes the rate limit status into the loop' do
      all_results = []
      @client.follower_ids('jack').each_page do |results, cursor|
        expect(cursor).not_to be_nil
        expect(cursor.next).not_to be_nil
        expect(cursor.rate_limit).not_to be_nil
        all_results << results
      end
      expect(all_results.size).to eq 2
      expect(all_results[0]).to match_array [20_009_713, 22_469_930, 351_223_419]
      expect(all_results[1]).to match_array [14_100_886, 14_509_199, 23_621_851]
    end
    it 'allows to break the loop based on rate limit status' do
      @client.follower_ids('jack').each_page do |_, cursor|
        break if cursor.rate_limit.remaining == 11
      end
      expect(a_get('/1.1/followers/ids.json').with(:query => {:cursor => '-1', :screen_name => 'jack'})).to have_been_made
      expect(a_get('/1.1/followers/ids.json').with(:query => {:cursor => '1305102810874389703', :screen_name => 'jack'})).not_to have_been_made
    end
    it 'works to pass start cursor to request' do
      first = @client.follower_ids('sferik')
      expect(first.attrs[:ids]).to match_array [20_009_713, 22_469_930, 351_223_419]
      second = @client.follower_ids('sferik', :cursor => first.next)
      expect(second.attrs[:ids]).to match_array [14_100_886, 14_509_199, 23_621_851]
      expect(second.next).to be 0
    end
  end

end
