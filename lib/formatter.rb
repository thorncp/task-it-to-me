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

  def format(message, style)
    "#{COLORS[style]}#{message}#{COLORS[:reset]}"
  end

  def command(key, description)
    format('%-4s' % key, :command) + format(description, :description)
  end
end
