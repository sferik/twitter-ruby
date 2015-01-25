require 'helper'

describe Twitter::Streaming::Control do
  let(:control_uri) { '/1.1/site/c/1_1_54e345d655ee3e8df359ac033648530bfbe26c5f' }

  before do
    @client = Twitter::Streaming::Control.new(consumer_key: 'CK', consumer_secret: 'CS', access_token: 'AT', access_token_secret: 'AS', control_uri: control_uri)
  end

  describe '#add_user' do
    context 'with a single user_id passed' do
      before do
        stub_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: '123456'}).to_return(status: 200, body: '', headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.add_user(123_456)
        expect(a_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: '123456'})).to have_been_made
      end
      it 'returns true when successful' do
        expect(@client.add_user(123_456)).to be_truthy
      end
    end
    context 'with a user passed' do
      let(:user) { Twitter::User.new(id: '7505382') }
      before do
        stub_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: user.id}).to_return(status: 200, body: '', headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.add_user(user)
        expect(a_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: user.id})).to have_been_made
      end
      it 'returns true when successful' do
        expect(@client.add_user(user)).to be_truthy
      end
    end
    context 'with an array of user_ids passed' do
      before do
        stub_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: '123456,7505382'}).to_return(status: 200, body: '', headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.add_user(123_456, 7_505_382)
        expect(a_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: '123456,7505382'})).to have_been_made
      end
      it 'returns true when successful' do
        expect(@client.add_user(123_456, 7_505_382)).to be_truthy
      end
    end
    context 'with an array of users passed' do
      let(:user1) { Twitter::User.new(id: '123456') }
      let(:user2) { Twitter::User.new(id: '7505382') }

      before do
        stub_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: '123456,7505382'}).to_return(status: 200, body: '', headers: {content_type: 'application/json; charset=utf-8'})
      end
      it 'requests the correct resource' do
        @client.add_user(user1, user2)
        expect(a_post("#{control_uri}/add_user.json", described_class).with(body: {user_id: '123456,7505382'})).to have_been_made
      end
      it 'returns true when successful' do
        expect(@client.add_user(user1, user2)).to be_truthy
      end
    end
  end

  describe '#remove_user' do
    before do
      stub_post("#{control_uri}/remove_user.json", described_class).with(body: {user_id: '123456'}).to_return(status: 200, body: '', headers: {content_type: 'application/json; charset=utf-8'})
    end
    it 'requests the correct resource' do
      @client.remove_user(123_456)
      expect(a_post("#{control_uri}/remove_user.json", described_class).with(body: {user_id: '123456'})).to have_been_made
    end
    it 'returns true when successful' do
      expect(@client.remove_user(123_456)).to be_truthy
    end
  end
end
