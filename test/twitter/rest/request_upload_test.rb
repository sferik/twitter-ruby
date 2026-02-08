require "test_helper"

describe Twitter::REST::Request do
  before do
    @client = build_rest_client
  end
  describe "#set_multipart_options!" do
    let(:temp_dir) { Dir.mktmpdir }

    after do
      FileUtils.rm_rf(temp_dir)
    end

    it "sets request_method to :post for :multipart_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      request = Twitter::REST::Request.new(@client, :multipart_post, "/test.json", {}, {key: :media, file: file})

      assert_equal(:post, request.request_method)
      file.close
    end

    it "sets request_method to :post for :json_post" do
      request = Twitter::REST::Request.new(@client, :json_post, "/test.json", {data: "value"})

      assert_equal(:post, request.request_method)
    end

    it "sets request_method to :put for :json_put" do
      request = Twitter::REST::Request.new(@client, :json_put, "/test.json", {data: "value"})

      assert_equal(:put, request.request_method)
    end

    it "keeps request_method for :get" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})

      assert_equal(:get, request.request_method)
    end

    it "keeps request_method for :delete" do
      request = Twitter::REST::Request.new(@client, :delete, "/test.json", {})

      assert_equal(:delete, request.request_method)
    end

    it "keeps request_method for :post" do
      request = Twitter::REST::Request.new(@client, :post, "/test.json", {})

      assert_equal(:post, request.request_method)
    end

    it "calls merge_multipart_file! for :multipart_post but not for :json_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      params = {key: :media, file: file}

      # For multipart_post, the params should have :media set to HTTP::FormData::File
      Twitter::REST::Request.new(@client, :multipart_post, "/test.json", {}, params)

      # After initialization, the params should have been modified
      assert_kind_of(HTTP::FormData::File, params[:media])
      refute_operator(params, :key?, :key)
      refute_operator(params, :key?, :file)
      file.close
    end

    it "does not modify params for :json_post" do
      params = {key: :media, file: "should_remain"}

      Twitter::REST::Request.new(@client, :json_post, "/test.json", {}, params)

      # params should remain unchanged
      assert_equal(:media, params[:key])
      assert_equal("should_remain", params[:file])
    end

    it "creates headers with empty options for :multipart_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)

      # Headers should be created with empty options hash for multipart_post
      request = Twitter::REST::Request.new(@client, :multipart_post, "/test.json", {will_be_ignored: true}, {key: :media, file: file})

      # The headers are created and the request method should be :post
      assert_kind_of(Hash, request.headers)
      assert_equal(:post, request.request_method)
      file.close
    end

    it "creates headers with empty options for :json_post" do
      request = Twitter::REST::Request.new(@client, :json_post, "/test.json", {will_be_ignored: true})

      assert_kind_of(Hash, request.headers)
      assert_equal(:post, request.request_method)
    end

    it "passes client to Headers.new" do
      captured_args = nil
      original_headers_new = Twitter::Headers.method(:new)
      Twitter::Headers.stub(:new, lambda { |*args|
        captured_args = args
        original_headers_new.call(*args)
      }) do
        Twitter::REST::Request.new(@client, :get, "/test.json", {})
      end

      assert_equal(@client, captured_args[0])
    end

    it "passes request_method to Headers.new" do
      captured_args = nil
      original_headers_new = Twitter::Headers.method(:new)
      Twitter::Headers.stub(:new, lambda { |*args|
        captured_args = args
        original_headers_new.call(*args)
      }) do
        Twitter::REST::Request.new(@client, :get, "/test.json", {})
      end

      assert_equal(:get, captured_args[1])
    end

    it "passes transformed request_method :post to Headers.new for :json_post" do
      captured_args = nil
      original_headers_new = Twitter::Headers.method(:new)
      Twitter::Headers.stub(:new, lambda { |*args|
        captured_args = args
        original_headers_new.call(*args)
      }) do
        Twitter::REST::Request.new(@client, :json_post, "/test.json", {})
      end

      assert_equal(:post, captured_args[1])
    end

    it "passes uri to Headers.new" do
      builder = Object.new
      builder.define_singleton_method(:request_headers) { {} }
      captured_uri = nil

      Twitter::Headers.stub(:new, lambda { |_client, _method, uri, _opts|
        captured_uri = uri
        builder
      }) do
        Twitter::REST::Request.new(@client, :get, "/test.json", {})
      end

      assert_kind_of(Addressable::URI, captured_uri)
      assert_equal("https://api.twitter.com/test.json", captured_uri.to_s)
    end

    it "passes empty options to Headers.new for :multipart_post" do
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)

      builder = Object.new
      builder.define_singleton_method(:request_headers) { {} }
      captured_options = nil
      Twitter::Headers.stub(:new, lambda { |_client, _method, _uri, options|
        captured_options = options
        builder
      }) do
        Twitter::REST::Request.new(@client, :multipart_post, "/test.json", {will_be_ignored: true}, {key: :media, file: file})
      end

      assert_empty(captured_options)
      file.close
    end

    it "passes options to Headers.new for regular requests" do
      options = {foo: "bar"}
      captured_options = nil
      original_headers_new = Twitter::Headers.method(:new)
      Twitter::Headers.stub(:new, lambda { |*args|
        captured_options = args[3]
        original_headers_new.call(*args)
      }) do
        Twitter::REST::Request.new(@client, :get, "/test.json", options)
      end

      assert_equal(options, captured_options)
    end
  end

  describe "#merge_multipart_file!" do
    let(:temp_dir) { Dir.mktmpdir }

    after do
      FileUtils.rm_rf(temp_dir)
    end

    it "removes :key from options and sets it as the key for the file" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      refute_operator(options, :key?, :key)
      refute_operator(options, :key?, :file)
      assert_kind_of(HTTP::FormData::File, options[:media])
      file.close
    end

    it "creates HTTP::FormData::File with correct content_type for gif" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      assert_equal("image/gif", options[:media].content_type)
      file.close
    end

    it "creates HTTP::FormData::File with correct content_type for jpeg" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      jpg_file = File.join(temp_dir, "test.jpg")
      File.write(jpg_file, "\xFF\xD8\xFF")
      file = File.new(jpg_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      assert_equal("image/jpeg", options[:media].content_type)
      file.close
    end

    it "creates HTTP::FormData::File with correct content_type for png" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      png_file = File.join(temp_dir, "test.png")
      File.write(png_file, "\x89PNG")
      file = File.new(png_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      assert_equal("image/png", options[:media].content_type)
      file.close
    end

    it "creates HTTP::FormData::File with correct filename for regular files" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "myimage.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      # Verify that filename parameter is used
      assert_equal("myimage.gif", options[:media].filename)
      # Verify a different filename to ensure it's not defaulting
      refute_equal("test.gif", options[:media].filename)
      file.close
    end

    it "passes filename to HTTP::FormData::File.new (not just file path)" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      unique_name = "unique_#{Time.now.to_i}.gif"
      gif_file = File.join(temp_dir, unique_name)
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      original_form_file_new = HTTP::FormData::File.method(:new)
      constructor_args = nil
      constructor_options = nil
      HTTP::FormData::File.stub(:new, lambda { |file_arg, **opts|
        constructor_args = file_arg
        constructor_options = opts
        original_form_file_new.call(file_arg, **opts)
      }) do
        request.send(:merge_multipart_file!, options)
      end

      assert_equal(file, constructor_args)
      assert_equal(%i[content_type filename], constructor_options.keys.sort)
      assert_equal(unique_name, constructor_options[:filename])
      assert_equal("image/gif", constructor_options[:content_type])
      assert_equal(unique_name, options[:media].filename)
      assert_equal("image/gif", options[:media].content_type)
      file.close
    end

    it "uses the file object for regular file uploads" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "data.gif")
      File.write(gif_file, "GIF89a content here")
      file = File.new(gif_file)
      options = {key: :media, file: file}

      request.send(:merge_multipart_file!, options)

      # Verify the file content is used (size matches file size)
      assert_equal("GIF89a content here".length, options[:media].size)
      file.close
    end

    it "handles StringIO files with video/mp4 content type" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      string_io = StringIO.new("video data")
      options = {key: :media, file: string_io}

      request.send(:merge_multipart_file!, options)

      assert_kind_of(HTTP::FormData::File, options[:media])
      assert_equal("video/mp4", options[:media].content_type)
      # Verify the file content is actually used (size > 0)
      assert_equal(10, options[:media].size) # "video data".length
    end

    it "sets application/octet-stream for unknown file types" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      bin_file = File.join(temp_dir, "test.bin")
      File.write(bin_file, "binary data")
      file = File.new(bin_file)
      options = {key: :data, file: file}

      request.send(:merge_multipart_file!, options)

      assert_kind_of(HTTP::FormData::File, options[:data])
      assert_equal("application/octet-stream", options[:data].content_type)
      file.close
    end

    it "uses the correct key from options" do
      request = Twitter::REST::Request.new(@client, :get, "/test.json", {})
      gif_file = File.join(temp_dir, "test.gif")
      File.write(gif_file, "GIF89a")
      file = File.new(gif_file)
      options = {key: :custom_key, file: file}

      request.send(:merge_multipart_file!, options)

      assert_operator(options, :key?, :custom_key)
      assert_kind_of(HTTP::FormData::File, options[:custom_key])
      file.close
    end
  end

  describe "proxy configuration" do
    it "uses proxy with username and password" do
      client = build_rest_client(proxy: {host: "127.0.0.1", port: 3328, username: "user", password: "pass"})
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
      original_via = HTTP.method(:via)
      via_args = []
      HTTP.stub(:via, lambda { |*args|
        via_args << args
        original_via.call(*args)
      }) do
        client.update("Update")
      end

      assert_equal([["127.0.0.1", 3328, "user", "pass"]], via_args)
    end

    it "uses proxy with only username" do
      client = build_rest_client(proxy: {host: "127.0.0.1", port: 3328, username: "user"})
      stub_post("/1.1/statuses/update.json").with(body: {status: "Update"}).to_return(body: fixture("status.json"), headers: json_headers)
      original_via = HTTP.method(:via)
      via_args = []
      HTTP.stub(:via, lambda { |*args|
        via_args << args
        original_via.call(*args)
      }) do
        client.update("Update")
      end

      assert_equal([["127.0.0.1", 3328, "user"]], via_args)
    end
  end
end
