module RestUsersProfileImageExamples
  def profile_image_upload_examples(method_name:, path:, fixture_name:, option_key:)
    describe "##{method_name}" do
      before do
        stub_json_post(path, body: fixture("sferik.json"))
      end

      profile_image_requests_correct_resource_example(method_name:, path:, fixture_name:)
      profile_image_returns_user_example(method_name:, fixture_name:)
      profile_image_with_options_example(method_name:, path:, fixture_name:, option_key:)
      profile_image_multipart_upload_example(method_name:, path:, fixture_name:, option_key:)
    end
  end

  private

  def profile_image_requests_correct_resource_example(method_name:, path:, fixture_name:)
    it "requests the correct resource" do
      @client.public_send(method_name, fixture_file(fixture_name))

      assert_requested(a_post(path))
    end
  end

  def profile_image_returns_user_example(method_name:, fixture_name:)
    it "returns a user" do
      user = @client.public_send(method_name, fixture_file(fixture_name))

      assert_kind_of(Twitter::User, user)
      assert_equal(7_505_382, user.id)
    end
  end

  def profile_image_with_options_example(method_name:, path:, fixture_name:, option_key:)
    describe "with options" do
      it "passes options in the request" do
        @client.public_send(method_name, fixture_file(fixture_name), option_key => true)

        assert_requested(a_post(path).with do |req|
          req.body.include?(option_key.to_s)
        end)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def profile_image_multipart_upload_example(method_name:, path:, fixture_name:, option_key:)
    it "uses multipart upload with :image key" do
      image = fixture_file(fixture_name)
      request = Object.new
      request.define_singleton_method(:perform) { {id: 7_505_382} }

      user = nil
      Twitter::REST::Request.stub(:new, lambda { |client, method, request_path, options|
        assert_equal(@client, client)
        assert_equal(:multipart_post, method)
        assert_equal(path, request_path)
        assert(options[option_key])
        assert_equal(:image, options[:key])
        assert_equal(image, options[:file])
        request
      }) do
        user = @client.public_send(method_name, image, option_key => true)
      end

      assert_kind_of(Twitter::User, user)
      assert_equal(7_505_382, user.id)
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end

Minitest::Spec.extend(RestUsersProfileImageExamples)
