require_relative 'test_helper'

class TestPrint < Minitest::Test
  def printer
    @printer ||= Print.new(output)
  end

  def output
    @output ||= StringIO.new("")
  end

  def test_format_of_project_create_prompt
    printer.project_name_prompt
    assert_includes(output.string, Formatter::COLORS[:description])
  end
end
