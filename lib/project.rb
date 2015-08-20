class Project
  attr_reader   :tasks
  attr_accessor :name

  def initialize(name)
    @name = name
    @tasks = []
  end
end
