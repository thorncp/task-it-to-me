class Formatter
  COLORS = {
    success: "[38;5;40m",
    reset: "\e[0m",
    alert: "\e[40;38;5;214m",
    command: "\e[1;37",
    description: "\e[0;35m"
  }

  def format(message, style)
    "#{COLORS[style]}#{message}#{COLORS[:reset]}"
  end
end
