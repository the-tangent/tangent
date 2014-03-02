module Persistence
  class ArticleImageService
    def initialize(storage)
      @storage = storage
    end

    def upload(id, file)
      scope = "article#{id}"
      file_name = file[:filename]
      file_body = file[:tempfile]

      file = @storage.files.create(
        :key => "#{scope}-#{file_name}",
        :body => file_body,
        :public => true
      )

      file.public_url
    end
  end
end
