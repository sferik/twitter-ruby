require File.expand_path('../../../spec_helper', __FILE__)

describe Twitter::Client do
  Twitter::Configuration::VALID_FORMATS.each do |format|
    context ".new(:format => '#{format}')" do
      before do
        @client = Twitter::Client.new(:format => format, :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      end

      describe ".list_members" do

        context "with screen name" do

          before do
            stub_get("sferik/presidents/members.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("users_list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_members("sferik", "presidents")
            a_get("sferik/presidents/members.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

          it "should return the members of the specified list" do
            users_list = @client.list_members("sferik", "presidents")
            users_list.users.should be_an Array
            users_list.users.first.name.should == "Erik Michaels-Ober"
          end

        end

        context "without screen name" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_get("sferik/presidents/members.#{format}").
              with(:query => {:cursor => "-1"}).
              to_return(:body => fixture("users_list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_members("presidents")
            a_get("sferik/presidents/members.#{format}").
              with(:query => {:cursor => "-1"}).
              should have_been_made
          end

        end

      end

      describe ".list_add_member" do

        context "with screen name passed" do

          before do
            stub_post("sferik/presidents/members.#{format}").
              with(:body => {:id => "813286"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_add_member("sferik", "presidents", 813286)
            a_post("sferik/presidents/members.#{format}").
              with(:body => {:id => "813286"}).
              should have_been_made
          end

          it "should return the list" do
            list = @client.list_add_member("sferik", "presidents", 813286)
            list.name.should == "presidents"
          end

        end

        context "without screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_post("sferik/presidents/members.#{format}").
              with(:body => {:id => "813286"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_add_member("presidents", 813286)
            a_post("sferik/presidents/members.#{format}").
              with(:body => {:id => "813286"}).
              should have_been_made
          end

        end

      end

      describe ".list_add_members" do

        context "with screen name passed" do

          before do
            stub_post("sferik/presidents/create_all.#{format}").
              with(:body => {:user_id => "813286,18755393"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_add_members("sferik", "presidents", [813286, 18755393])
            a_post("sferik/presidents/create_all.#{format}").
              with(:body => {:user_id => "813286,18755393"}).
              should have_been_made
          end

          it "should return the list" do
            list = @client.list_add_members("sferik", "presidents", [813286, 18755393])
            list.name.should == "presidents"
          end

        end

        context "without screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_post("sferik/presidents/create_all.#{format}").
              with(:body => {:user_id => "813286,18755393"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_add_members("presidents", [813286, 18755393])
            a_post("sferik/presidents/create_all.#{format}").
              with(:body => {:user_id => "813286,18755393"}).
              should have_been_made
          end

        end

      end

      describe ".list_remove_member" do

        context "with screen name passed" do

          before do
            stub_delete("sferik/presidents/members.#{format}").
              with(:query => {:id => "813286"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_remove_member("sferik", "presidents", 813286)
            a_delete("sferik/presidents/members.#{format}").
              with(:query => {:id => "813286"}).
              should have_been_made
          end

          it "should return the list" do
            list = @client.list_remove_member("sferik", "presidents", 813286)
            list.name.should == "presidents"
          end

        end

        context "without screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_delete("sferik/presidents/members.#{format}").
              with(:query => {:id => "813286"}).
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.list_remove_member("presidents", 813286)
            a_delete("sferik/presidents/members.#{format}").
              with(:query => {:id => "813286"}).
              should have_been_made
          end

        end

      end

      describe ".is_list_member?" do

        context "with screen name passed" do

          before do
            stub_get("sferik/presidents/members/813286.#{format}").
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
            stub_get("sferik/presidents/members/65493023.#{format}").
              to_return(:body => fixture("not_found.#{format}"), :status => 404, :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.is_list_member?("sferik", "presidents", 813286)
            a_get("sferik/presidents/members/813286.#{format}").
              should have_been_made
          end

          it "should return true if user is a list member" do
            is_list_member = @client.is_list_member?("sferik", "presidents", 813286)
            is_list_member.should be_true
          end

          it "should return false if user is not a list member" do
            is_list_member = @client.is_list_member?("sferik", "presidents", 65493023)
            is_list_member.should be_false
          end

        end

        context "without screen name passed" do

          before do
            @client.stub!(:get_screen_name).and_return('sferik')
            stub_get("sferik/presidents/members/813286.#{format}").
              to_return(:body => fixture("list.#{format}"), :headers => {:content_type => "application/#{format}; charset=utf-8"})
            stub_get("sferik/presidents/members/65493023.#{format}").
              to_return(:body => fixture("not_found.#{format}"), :status => 404, :headers => {:content_type => "application/#{format}; charset=utf-8"})
          end

          it "should get the correct resource" do
            @client.is_list_member?("presidents", 813286)
            a_get("sferik/presidents/members/813286.#{format}").
              should have_been_made
          end

        end

      end
    end
  end
end
