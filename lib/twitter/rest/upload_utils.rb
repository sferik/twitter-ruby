require "twitter/rest/request"

module Twitter
  module REST
    # Utilities for uploading media to Twitter
    #
    # @api private
    module UploadUtils
      private

      # Uploads images and videos to Twitter
      #
      # @api private
      # @see https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
      # @return [Hash]
      def upload(media, media_category_prefix: "tweet")
        ext = File.extname(media)
        return chunk_upload(media, "video/mp4", "#{media_category_prefix}_video") if ext == ".mp4"
        return chunk_upload(media, "video/quicktime", "#{media_category_prefix}_video") if ext == ".mov"
        return chunk_upload(media, "image/gif", "#{media_category_prefix}_gif") if ext == ".gif" && File.size(media) > 5_000_000

        Request.new(self, :multipart_post, "https://upload.twitter.com/1.1/media/upload.json", key: :media, file: media).perform
      end

      # Uploads large media in chunks
      #
      # @api private
      # @raise [Twitter::Error::TimeoutError] Error raised when the upload is longer than the value specified in Twitter::Client#timeouts[:upload].
      # @raise [Twitter::Error::MediaError] Error raised when Twitter return an error about a media which is not mapped by the gem.
      # @raise [Twitter::Error::MediaInternalError] Error raised when Twitter returns an InternalError error.
      # @raise [Twitter::Error::InvalidMedia] Error raised when Twitter returns an InvalidMedia error.
      # @raise [Twitter::Error::UnsupportedMedia] Error raised when Twitter returns an UnsupportedMedia error.
      # @see https://developer.twitter.com/en/docs/media/upload-media/uploading-media/chunked-media-upload
      # @return [Hash]
      def chunk_upload(media, media_type, media_category)
        Timeout.timeout(timeouts&.fetch(:upload, nil), Error::TimeoutError) do # steep:ignore UnknownConstant,NoMethod
          init = Request.new(self, :post, "https://upload.twitter.com/1.1/media/upload.json",
            command: "INIT",
            media_type:,
            media_category:,
            total_bytes: media.size).perform
          append_media(media, init.fetch(:media_id))
          media.close
          finalize_media(init.fetch(:media_id))
        end
      end

      # Appends media chunks
      #
      # @api private
      # @see https://developer.twitter.com/en/docs/media/upload-media/api-reference/post-media-upload-append
      # @return [void]
      def append_media(media, media_id)
        until media.eof?
          chunk = media.read(5_000_000)
          seg ||= -1
          Request.new(self, :multipart_post, "https://upload.twitter.com/1.1/media/upload.json",
            command: "APPEND",
            media_id:,
            segment_index: seg += 1,
            key: :media,
            file: StringIO.new(chunk)).perform
        end
      end

      # Finalizes a media upload
      #
      # @api private
      # @see https://developer.twitter.com/en/docs/media/upload-media/api-reference/post-media-upload-finalize
      # @see https://developer.twitter.com/en/docs/media/upload-media/api-reference/get-media-upload-status
      # @return [Hash]
      def finalize_media(media_id)
        response = Request.new(self, :post, "https://upload.twitter.com/1.1/media/upload.json",
          command: "FINALIZE", media_id:).perform
        terminal_states = %w[failed succeeded]

        loop do
          processing_info = response[:processing_info]
          return response if !processing_info || terminal_states.include?(processing_info[:state])

          sleep(processing_info.fetch(:check_after_secs))
          response = Request.new(self, :get, "https://upload.twitter.com/1.1/media/upload.json",
            command: "STATUS", media_id:).perform
        end
      end
    end
  end
end
