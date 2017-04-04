require 'simplecov'
SimpleCov.start
if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "serrano"
require 'fileutils'
require "test/unit"
require "json"

class TestTypes < Test::Unit::TestCase

  def setup
    @id = "journal"
    @ids = ["journal", "dissertation"]
  end

  def test_types_no_ids
    res = Serrano.types()
    assert_equal(4, res.length)
    assert_equal(Hash, res.class)
    assert_equal("type-list", res['message-type'])
  end

  def test_types_single_id
    res = Serrano.types(ids: @id)
    assert_equal(1, res.length)
    assert_equal(Array, res.class)
    assert_equal(Hash, res[0].class)
    assert_equal("type", res[0]['message-type'])
  end

  def test_types_many_ids
    res = Serrano.types(ids: @ids)
    assert_equal(2, res.length)
    assert_equal(Array, res.class)
    assert_equal(Hash, res[0].class)
    assert_equal("type", res[0]['message-type'])
    assert_equal("journal", res[0]['message']['id'])
  end

end