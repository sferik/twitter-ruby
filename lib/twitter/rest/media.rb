module Twitter
  module REST
    module Media
      include Twitter::REST::Utils

      # Uploads images and videos. Videos require multiple requests and uploads in chunks of 5 Megabytes.
      # The only supported video format is mp4.
      #
      # @see https://dev.twitter.com/rest/public/uploading-media
      def upload_media(media) # rubocop:disable MethodLength
        if !(File.basename(media) =~ /\.mp4$/)
          perform_request(:multipart_post, 'https://upload.twitter.com/1.1/media/upload.json', key: :media, file: media)
        else
          init = perform_request(:post, 'https://upload.twitter.com/1.1/media/upload.json',
                                 command: 'INIT',
                                 media_type: 'video/mp4',
                                 total_bytes: media.size)

          media_id = init[:media_id]

          until media.eof?
            chunk = media.read(5_000_000)
            seg ||= -1
            perform_request(:multipart_post, 'https://upload.twitter.com/1.1/media/upload.json',
                            command: 'APPEND',
                            media_id: media_id,
                            segment_index: seg += 1,
                            key: :media,
                            file: StringIO.new(chunk))
          end

          media.close

          perform_request(:post, 'https://upload.twitter.com/1.1/media/upload.json',
                          command: 'FINALIZE',
                          media_id: media_id)
        end
      end
    end
  end
end
