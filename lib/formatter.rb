class Formatter
  COLORS = {
    success: "\e[38;5;40m",
    reset: "\e[0m",
    alert: "\e[40;38;5;214m",
    command: "\e[1;37m",
    description: "\e[0;35m",
    prompt: "\e[0;35m",
    dividing_line: "\e[1;37m"
  }

  attr_reader :output_stream, :aggregated_message

  def initialize(output_stream)
    @output_stream = output_stream
    reset_aggregator
  end

  def command_menu(key, description)
    command('%-4s' % key)
    description(description)
    add_line
  end

  def add(message, style=nil)
    aggregated_message << format(message, style)
    self
  end

  COLORS.keys.each do |name|
    define_method(name) do |message|
      add(message, name)
    end
  end

  def add_line
    aggregated_message << "\n"
    self
  end

  alias :end_line :add_line

  def add_separator
    add_line
    add_line
  end

  def add_small_rule
    add("-----------------------------", :dividing_line)
    add_line
  end

  def add_large_rule
    add("=============================", :dividing_line)
    add_line
  end

  def add_menu_header(menu_title)
    command(menu_title)
    end_line
    add_small_rule
    alert("ENTER A COMMAND:")
    end_line
  end

  def list(collection)
    collection.each do |object|
      item(object)
    end
    add_separator
  end

  def item(object)
    add("  #{object.position}.  ")
    description("#{object.name}")
    end_line
  end

  def send_to_output
    output_stream.puts(aggregated_message)
    reset_aggregator
    self
  end

  def success_with_name(message, name)
    add_with_name(message, name, :success)
  end

  def alert_with_name(message, name)
    add_with_name(message, name, :alert)
  end

  def change_name(message, old_name, new_name)
    success(message)
    add(" '#{old_name}' ")
    success("to")
    add(" '#{new_name}'")
    add_separator
  end

  private

  def format(message, style)
    return message unless style
    "#{COLORS[style]}#{message}#{COLORS[:reset]}"
  end

  def add_with_name(message, name, style)
    add(message, style)
    add(" '#{name}'")
    add_separator
  end

  def reset_aggregator
    @aggregated_message = ""
  end
end
