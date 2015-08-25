require_relative 'test_helper'

class TestPersistence < Minitest::Test
  def persistence
    @persistence ||= Persistence.new
  end

  def persisted_content
    File.read(persistence.path)
  end

  def test_writing_to_json_file
    persistence.save({hello: 'world'})
    assert_equal({hello: 'world'}.to_json, persisted_content)
  end

  def test_load
    File.open(persistence.path, 'w') {|file| file.write({waz: 'up!'}.to_json)}
    assert_equal(persistence.load,{'waz' => 'up!'})
  end

  def test_loading_bad_data
    File.open(persistence.path, 'w') {|file| file.write('(gerbil}}!')}
    assert_equal(persistence.load, [])
  end
end
