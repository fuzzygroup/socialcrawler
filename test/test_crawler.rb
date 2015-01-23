require 'test_helper'
require "test/unit"
require 'semantic'
require 'socialcrawler'

class CrawlewrTest < Test::Unit::TestCase

  def test_version
    s = SocialCrawler::VERSION
    v = Semantic::Version.new(s)
    assert_equal v.to_s, s
  end

  def test_1
    File.delete('/tmp/test_out.txt') if File.exists?('/tmp/test_out.txt')
    File.delete('/tmp/test_status.txt') if File.exists?('/tmp/test_status.txt')

    sc = SocialCrawler::SocialCrawler.new
    sc.crawl('test/test_url.txt', '/tmp/test_out.txt', '/tmp/test_status.txt')

    sc = SocialCrawler::SocialCrawler.new
    sc.crawl('test/test_url.txt', '/tmp/test_out.txt', '/tmp/test_status.txt')
    
    sc = SocialCrawler::SocialCrawler.new
    sc.crawl('test/test_url.txt', '/tmp/test_out.txt', 'test_status.txt')
   end

end