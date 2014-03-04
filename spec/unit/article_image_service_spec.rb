require_relative "../../lib/persistence/database"
require_relative "../../lib/persistence/article_service"

describe Persistence::ArticleService do
  let(:storage) { TestFogBucket.new }
  let(:service) { Persistence::ArticleImageService.new(storage) }

  describe "#upload" do
    it "uploads the file publically" do
      file = { :filename => "test.png", :tempfile => Tempfile.new("test.png") }
      id = "1"

      service.upload(id, file)

      expect(storage.files.length).to eq(1)
      expect(storage.files.first.key).to eq("article1-test.png")
      expect(storage.files.first.body).to eq(file[:tempfile])
      expect(storage.files.first.public).to eq(true)
    end
  end

  private

  class TestFogBucket
    def initialize
      @files = []
    end

    def files
      self
    end

    def create(file)
      @files << OpenStruct.new(file)
      OpenStruct.new(:public_url => "")
    end

    def length
      @files.length
    end

    def first
      @files.first
    end
  end
end
