require 'spec_helper'

describe 'Page' do
  let(:page) { Page.new }

  before :each do
    page.address = "https://en.wikipedia.org/wiki/New_Zealand_English"
  end

  context 'parsing a given page' do
    it 'returns a nokogiri object' do
      expect(page.parse_page.class).to eq Nokogiri::HTML::Document
    end
  end

  context 'page title' do
    it 'fetchs a page title' do
      doc = page.parse_page
      expect(page.set_title(doc)).to eq "New Zealand English"
    end

    it 'sets the page objects title' do
      doc = page.parse_page
      expect{page.set_title(doc)}.to change{page.title}.from(nil).to("New Zealand English")
    end
  end

  context 'word count' do
    it 'returns an number' do
      doc = page.parse_page
      expect(page.word_count(doc)).to be_a(Fixnum)
    end

    it 'updates the page word count' do
      doc = page.parse_page
      expect{page.word_count(doc)}.to change{page.words}.from(nil).to(5681)
    end
  end
end
