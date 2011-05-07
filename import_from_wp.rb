require 'rubygems'
require 'wpxml_parser'
require 'nanoc3'
require 'fileutils'
require 'time'
require 'nokogiri'

XML_PATH = 'data.xml'
NANOC_PATH = '.'

class WordpressNanocImporter
  include WpxmlParser

  def initialize(source_xml_path, target_path)
    @target_path = target_path
    @blog = Blog.new(source_xml_path)
  end
  
  def run
    FileUtils.cd(@target_path) do
      site = Nanoc3::Site.new('.')

      @blog.posts.each do |post|
        attributes = build_post_attributes(post)
        identifier = build_post_identifier(post)
        body=<<POST_BODY
<p>
#{post.body.gsub("\n","<br>")}
</p>

POST_BODY

        site.data_sources[0].create_item(body, attributes, identifier)
      end
    end
  end

  private

  def build_post_attributes(post)
    time = Time.parse(post.date).utc - 25200 #7 hours
    { :title      => post.title, 
      :excerpt    => Nokogiri::HTML::DocumentFragment.parse(post.body).text[0,200] + '...',
      :created_at => "#{time.year}/#{time.month.to_s.rjust(2,'0')}/#{time.day.to_s.rjust(2,'0')}",
      :kind       => "article",
      :tags       => post.categories }
  end
  
  def build_post_identifier(post)
  	time = Time.parse(post.date).utc - 25200 #7 hours
    "/#{time.year}/#{time.month.to_s.rjust(2,'0')}/#{time.day.to_s.rjust(2,'0')}/#{post.slug}/"
  end
end

importer = WordpressNanocImporter.new(XML_PATH, NANOC_PATH)
importer.run
