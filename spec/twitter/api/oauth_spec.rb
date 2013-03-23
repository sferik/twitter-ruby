require 'helper'

describe Twitter::API::OAuth do

  before do
    @client = Twitter::Client.new
  end
 
  describe "#bearer_token" do
  	#stub_post("/1.1//oauth2/token/16129012.json").to_return(:body => fixture("token.json"), :headers => {:content_type => "application/json; charset=utf-8"})
  end


end