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
end
