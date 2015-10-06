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

  attr_reader :output_stream, :aggregated_message, :persistence

  def initialize
    reset_aggregator
    @persistence = Persistence.new(color_configuration_path)
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

  def flush
    output = aggregated_message.dup
    reset_aggregator
    output
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

  def colors
    configured_colors.inject(COLORS.dup) do |combined_colors, key_value|
      combined_colors[key_value.first.to_sym] = "\e[#{key_value.last}m"
      combined_colors
    end
  end

  private

  def configured_colors
    @configured_colors ||= persistence.load
  rescue
    {}
  end

  def format(message, style)
    return message unless style
    "#{colors[style]}#{message}#{colors[:reset]}"
  end

  def add_with_name(message, name, style)
    add(message, style)
    add(" '#{name}'")
    add_separator
  end

  def reset_aggregator
    @aggregated_message = ""
  end

  def color_configuration_path
    File.expand_path( File.dirname(__FILE__) + "/../data/color.json" )
  end
end
