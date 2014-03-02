module Persistence
  class ImageUploader
    def initialize(file, storage)
      @file = file
      @storage = storage
    end

    def upload(scope)
      file_name = @file[:filename]
      file_body = @file[:tempfile]

      file = @storage.files.create(
        :key => "#{scope}-#{file_name}",
        :body => file_body,
        :public => true
      )

      file.public_url
    end
  end
end
