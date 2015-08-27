class Menu
  attr_accessor :name, :commands, :header, :data

  def initialize(name, commands)
    @name = name
    @commands = commands
  end
end
