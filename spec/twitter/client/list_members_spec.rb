require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Twitter::Client" do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".list_members" do

        before do
          stub_get("pengwynn/Rubyists/members.#{format}").
            to_return(:body => fixture("users_list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_members("pengwynn", "Rubyists")
          a_get("pengwynn/Rubyists/members.#{format}").
            should have_been_made
        end

        it "should return the members of the specified list" do
          users_list = @client.list_members("pengwynn", "Rubyists")
          users_list.users.should be_an Array
          users_list.users.first.name.should == "Erik Michaels-Ober"
        end

      end

      describe ".list_add_member" do

        before do
          stub_post("pengwynn/Rubyists/members.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_add_member("pengwynn", "Rubyists", 7505382)
          a_post("pengwynn/Rubyists/members.#{format}").
            should have_been_made
        end

        it "should return the list" do
          list = @client.list_add_member("pengwynn", "Rubyists", 7505382)
          list.name.should == "Rubyists"
        end

      end

      describe ".list_add_members" do

        before do
          stub_post("pengwynn/Rubyists/create_all.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_add_members("pengwynn", "Rubyists", [7505382, 14100886])
          a_post("pengwynn/Rubyists/create_all.#{format}").
            should have_been_made
        end

        it "should return the list" do
          list = @client.list_add_members("pengwynn", "Rubyists", [7505382, 14100886])
          list.name.should == "Rubyists"
        end

      end

      describe ".list_remove_member" do

        before do
          stub_delete("pengwynn/Rubyists/members.#{format}").
            with(:query => {"id" => "7505382"}).
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.list_remove_member("pengwynn", "Rubyists", 7505382)
          a_delete("pengwynn/Rubyists/members.#{format}").
            with(:query => {"id" => "7505382"}).
            should have_been_made
        end

        it "should return the list" do
          list = @client.list_remove_member("pengwynn", "Rubyists", 7505382)
          list.name.should == "Rubyists"
        end

      end

      describe ".is_list_member?" do

        before do
          stub_get("pengwynn/Rubyists/members/4243.#{format}").
            to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          stub_get("pengwynn/Rubyists/members/7505382.#{format}").
            to_return(:body => fixture("not_found.#{format}"), :status => 404, :headers => {:content_type => "application/#{format}; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.is_list_member?("pengwynn", "Rubyists", 4243)
          a_get("pengwynn/Rubyists/members/4243.#{format}").
            should have_been_made
        end

        it "should return true if user is a list member" do
          is_list_member = @client.is_list_member?("pengwynn", "Rubyists", 4243)
          is_list_member.should be_true
        end

        it "should return false if user is not a list member" do
          is_list_member = @client.is_list_member?("pengwynn", "Rubyists", 7505382)
          is_list_member.should be_false
        end
      end
    end
  end
end
