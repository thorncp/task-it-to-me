require_relative 'test_helper'

class TestFormatter < Minitest::Test
  def formatter
    @formatter ||= Formatter.new(output_stream)
  end

  def output_stream
    @output_stream ||= StringIO.new("")
  end

  def test_add_aggregates_message_but_does_not_put_out
    formatter.add("foo")
    assert_equal("foo", formatter.aggregated_message)
    assert_equal("", output_stream.string)
  end

  def test_add_chaining
    formatter
      .add("foo")
      .add(" ")
      .add("bar")

    assert_equal("foo bar", formatter.aggregated_message)
    assert_equal("", output_stream.string)
  end

  def test_add_line
    formatter
      .add("foo")
      .add_line

    assert_equal("foo\n", formatter.aggregated_message)
    assert_equal("", output_stream.string)
  end

  def test_add_separator
    formatter
      .add("foo")
      .add_separator

    assert_equal("foo\n\n", formatter.aggregated_message)
    assert_equal("", output_stream.string)
  end

  def test_send_to_output
    formatter
      .add("foo")
      .add_separator
      .send_to_output

    assert_equal("foo\n\n",  output_stream.string)
    assert_equal("", formatter.aggregated_message)
  end

  def test_custom_styling_methods
    # Not exhaustive, just checks that metaprogramming worked
    formatter
      .alert("ALERT")
      .add_line
      .success("SUCCESS")
      .add_line
      .description("DESCRIPTION")

    assert_includes(formatter.aggregated_message, Formatter::COLORS[:alert])
    assert_includes(formatter.aggregated_message, Formatter::COLORS[:success])
    assert_includes(formatter.aggregated_message, Formatter::COLORS[:description])
  end
end

