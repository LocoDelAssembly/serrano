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

class TestResponse < Test::Unit::TestCase

  def setup
    @id = 98
    @ids = [98, 340, 45]
  end

  def test_members
    res = Serrano.members(ids: @id)
    assert_equal(4, res.length)
    # assert_equal(Array, res.class)
    # assert_equal(Hash, res[0].class)
    # assert_equal(200, res[0].status)
  end

  def test_members_many_ids
    res = Serrano.members(ids: @ids)
    assert_equal(4, res.length)
    # assert_equal(Array, res.class)
    # assert_equal(Hash, res[0].class)
    # assert_equal(200, res[0].status)
  end

  def test_members_query
    res = Serrano.members(query: "ecology")
    assert_equal(4, res.length)
    assert_equal(Hash, res.class)
    # assert_equal(200, res.status)
  end

  def test_members_works
    res = Serrano.members(ids: @id, works: true)
    assert_equal(4, res.length)
    assert_equal(Hash, res.class)
  end

  # should fail
  def test_members_filter_handler
    res = Serrano.members(filter: {has_funder: true, has_full_text: true})
    assert_equal(3, res.length)
    assert_equal(Hash, res.class)
    assert_equal('failed', res['status'])
    # assert_equal(200, res.status)
  end

end