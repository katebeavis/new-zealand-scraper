require 'spec_helper'
require 'open-uri'

describe 'WebScraper' do
  let(:web_scraper) { WebScraper.new 'https://en.wikipedia.org/wiki/List_of_New_Zealand-related_topics' }

  context 'parsing a given page' do
    it 'returns a nokogiri object' do
      expect(web_scraper.parse_page.class).to eq Nokogiri::HTML::Document
    end
  end

  context 'formatting links into the correct format' do
    it 'returns an array of links' do
      expect(web_scraper.find_links.class).to eq Array
    end

    it 'returns all the links from the pages' do
      expect(web_scraper.find_links.count).to eq 669
    end

    it 'removes links that do not start with wiki' do
      array = ["/wiki/New_Zealand_English", "https://www.wikidata.org/wiki/Q13644084", "#Lakes_and_rivers"]
      expect(web_scraper.select_wiki_links(array)).to eq ["/wiki/New_Zealand_English"]
    end

    it 'prefixes links with the wikipedia url' do
      array = ["/wiki/New_Zealand_English"]
      expect(web_scraper.prefix_links_with_url(array)).to eq ["https://en.wikipedia.org/wiki/New_Zealand_English"]
    end
  end

  context 'creating new page objects' do

    it 'creates new instances of pages for every link' do
      links = ["https://en.wikipedia.org/wiki/New_Zealand_English", "https://en.wikipedia.org/wiki/List_of_Cook_Islands-related_topics"]
      expect{web_scraper.create_page_objects(links)}.to change{web_scraper.pages.count}.from(0).to(2)
    end
  end

  context 'returning the page with the highest word count' do

    it 'returns the page with the highest number of words' do
      links = ["https://en.wikipedia.org/wiki/New_Zealand_English", "https://en.wikipedia.org/wiki/List_of_Cook_Islands-related_topics"]
      web_scraper.create_page_objects(links)
      web_scraper.set_page_attributes
      expect(web_scraper.page_with_highest_word_count.words).to eq 5681
    end

    it 'returns the title of page with the highest number of words' do
      links = ["https://en.wikipedia.org/wiki/New_Zealand_English", "https://en.wikipedia.org/wiki/List_of_Cook_Islands-related_topics"]
      web_scraper.create_page_objects(links)
      web_scraper.set_page_attributes
      expect(web_scraper.page_with_highest_word_count.title).to eq "New Zealand English"
    end
  end
end
