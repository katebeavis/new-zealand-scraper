require 'Nokogiri'
require './lib/page'
require 'open-uri'
require 'pry'
require 'pry-nav'

class WebScraper

  BASE_URL = "https://en.wikipedia.org"

  attr_reader :doc, :pages

  def initialize(file)
    @doc = (open(file))
    @pages = []
  end

  def get_longest_page
    links = format_and_prefix_links
    create_page_objects(links)
    set_page_attributes
    puts page_with_highest_word_count.title
  end

  # private

  def create_page_objects(links)
    links.map do |link|
      pages << Page.new(address = link)
    end
  end

  def set_page_attributes
    pages.map do |page|
      doc = page.parse_page
      page.word_count(doc)
      page.set_title(doc)
    end
  end

  def find_links
    parse_page.css('a').map { |link| link['href'] }
  end

  def select_wiki_links(links)
    links.select { |l| (l.to_s).start_with?('/wiki') }
  end

  def prefix_links_with_url(links)
    links.map { |l| BASE_URL + l }
  end

  def format_and_prefix_links
    links = find_links
    selected_links = select_wiki_links(links)
    prefix_links_with_url(selected_links)
  end

  def page_with_highest_word_count
    pages.max_by {|page| page.words }
  end

  def parse_page
    @parse_page ||= Nokogiri::HTML(doc)
  end

  # web_scraper = WebScraper.new('https://en.wikipedia.org/wiki/List_of_New_Zealand-related_topics')
  # web_scraper.get_longest_page
end
