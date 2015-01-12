require "test/unit"
require 'semantic'
require 'socialcrawler'
require 'test_helper'

class VersioningTest < Test::Unit::TestCase

  def test_version
    s = SocialCrawler::VERSION
    v = Semantic::Version.new(s)
    assert_equal v.to_s, s
  end

end