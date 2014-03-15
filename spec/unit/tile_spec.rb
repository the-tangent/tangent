require "spec_helper"

describe Widget::Tile do
  describe "#summary" do
    it "returns the paragraph of the article in plaintext" do
      tile = Widget::Tile.new(Persistence::Model.new(
        :id => 1,
        :title => "Title",
        :content => "First para\n\nSecond para"
      ))

      expect(tile.summary).to eq("First para")
    end

    it "returns the first paragraph for windows new lines" do
      tile = Widget::Tile.new(Persistence::Model.new(
        :id => 1,
        :title => "Title",
        :content => "First para\r\n\r\nSecond para"
      ))

      expect(tile.summary).to include("First para")
      expect(tile.summary).to_not include("Second para")
    end
  end
end
