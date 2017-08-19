module Twitter
  module REST
    module Media
      # Maximum number of times to poll twitter for upload status
      MAX_STATUS_CHECKS = 20

      # Use chunked uploading if file size is greater than 5MB
      CHUNKED_UPLOAD_THRESHOLD = (5 * 1024 * 1024)

      # Upload a media file to twitter
      #
      # @see https://dev.twitter.com/rest/reference/post/media/upload.html
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Integer] The media_id of the uploaded file.
      # @param file [File] An image (PNG, JPEG or GIF) or video (MP4) file.
      # @option options [String] :media_category Category with which to
      #   identify media upload. When this is specified, it enables async
      #   processing which allows larger uploads. See
      #   https://dev.twitter.com/rest/media/uploading-media for details.
      #   Possible values include tweet_image, tweet_gif, and tweet_video.
      def upload(file, options = {})
        if file.size < CHUNKED_UPLOAD_THRESHOLD
          upload_media_simple(file, options)
        else
          upload_media_chunked(file, options)
        end
      end

    private

      # Upload a media file to twitter in one request
      #
      # @see https://dev.twitter.com/rest/reference/post/media/upload.html
      # @note This is only for small files, use the chunked upload for larger ones.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Integer] The media_id of the uploaded file.
      # @param file [File] An image file (PNG, JPEG or GIF).
      # @option options [String] :media_category Category with which to
      #   identify media upload. When this is specified, it enables async
      #   processing which allows larger uploads. See
      #   https://dev.twitter.com/rest/media/uploading-media for details.
      #   Possible values include tweet_image, tweet_gif, and tweet_video.
      def upload_media_simple(file, options = {})
        Twitter::REST::Request.new(self,
                                   :multipart_post,
                                   'https://upload.twitter.com/1.1/media/upload.json',
                                   key: :media,
                                   file: file,
                                   **options).perform[:media_id]
      end

      # Upload a media file to twitter in chunks
      #
      # @see https://dev.twitter.com/rest/reference/post/media/upload.html
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Integer] The media_id of the uploaded file.
      # @param file [File] An image or video file (PNG, JPEG, GIF, or MP4).
      # @option options [String] :media_category Category with which to
      #   identify media upload. When this is specified, it enables async
      #   processing which allows larger uploads. See
      #   https://dev.twitter.com/rest/media/uploading-media for details.
      #   Possible values include tweet_image, tweet_gif, and tweet_video.
      def upload_media_chunked(file, options = {})
        media_id = chunked_upload_init(file, options)[:media_id]
        upload_chunks(media_id, file)
        poll_status(media_id)

        media_id
      end

      # Finalize upload and poll status until upload is ready
      #
      # @param media_id [Integer] The media_id to check the status of
      def poll_status(media_id)
        response = chunked_upload_finalize(media_id)
        MAX_STATUS_CHECKS.times do
          return unless (info = response[:processing_info])
          return if info[:state] == 'succeeded'

          raise Twitter::Error::ClientError, 'Upload Failed!' if info[:state] == 'failed'

          sleep info[:check_after_secs]

          response = chunked_upload_status(media_id)
        end

        raise Twitter::Error::ClientError, 'Max status checks exceeded!'
      end

      # Initialize a chunked upload
      #
      # @param file [File] Media file being uploaded
      # @param options [Hash] Additional parameters
      def chunked_upload_init(file, options)
        Twitter::REST::Request.new(self, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                                   command: 'INIT',
                                   media_type: 'video/mp4',
                                   total_bytes: file.size,
                                   **options).perform
      end

      # Append chunks to the upload
      #
      # @param media_id [Integer] The media_id of the file being uploaded
      # @param file [File] Media file being uploaded
      def upload_chunks(media_id, file)
        until file.eof?
          chunk = file.read(5_000_000)
          segment ||= -1
          segment += 1
          chunked_upload_append(chunk, segment, media_id)
        end

        file.close
      end

      # Append a chunk to the upload
      #
      # @param chunk [String] File chunk to upload
      # @param segment [Integer] Index of chunk in file
      # @param media_id [Integer] The media_id of the file being uploaded
      # @return [Hash] Response JSON
      def chunked_upload_append(chunk, segment, media_id)
        Twitter::REST::Request.new(self, :multipart_post, 'https://upload.twitter.com/1.1/media/upload.json',
                                   command: 'APPEND',
                                   media_id: media_id,
                                   segment_index: segment,
                                   key: :media,
                                   file: StringIO.new(chunk)).perform
      end

      # Finalize the upload. This returns the processing status if applicable
      #
      # @param media_id [Integer] The media_id of the file being uploaded
      # @return [Hash] Response JSON
      def chunked_upload_finalize(media_id)
        Twitter::REST::Request.new(self, :post, 'https://upload.twitter.com/1.1/media/upload.json',
                                   command: 'FINALIZE', media_id: media_id).perform
      end

      # Check processing status for async uploads
      #
      # @param media_id [Integer] The media_id of the file being uploaded
      # @return [Hash] Response JSON
      def chunked_upload_status(media_id)
        Twitter::REST::Request.new(self, :get, 'https://upload.twitter.com/1.1/media/upload.json',
                                   command: 'STATUS', media_id: media_id).perform
      end
    end
  end
end
