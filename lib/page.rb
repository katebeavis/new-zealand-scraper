class Page

  attr_accessor :address, :title, :words

  def initialize(address=nil, title=nil, words=nil)
    @address = address
    @title = title
    @words = words
  end

  def parse_page
    @doc ||= Nokogiri::HTML(open(address))
  end

  def title
    @title = @doc.css("h1#firstHeading").text
  end

  def word_count
    text = @doc.search('//text()').map(&:text)
    self.words = text.count
  end
end
