require_relative 'test_helper'

class TestPersistence < Minitest::Test
  def persistence
    @persistence ||= Persistence.new(path)
  end

  def path
    File.expand_path(File.dirname(__FILE__) + "/fixtures/projects.json")
  end

  def setup
    File.delete(path) if File.exist?(path)
    FileUtils.mkdir(File.dirname(path)) unless File.exist?(File.dirname(path))
  end

  def persisted_content
    File.read(path)
  end

  def test_writing_to_json_file
    persistence.save({hello: 'world'})
    assert_equal({hello: 'world'}.to_json, persisted_content)
  end

  def test_load
    File.open(path, 'w') {|file| file.write({waz: 'up!'}.to_json)}
    assert_equal(persistence.load,{'waz' => 'up!'})
  end

  def test_loading_bad_data
    File.open(path, 'w') {|file| file.write('(gerbil}}!')}
    assert_equal(persistence.load, [])
  end
end
