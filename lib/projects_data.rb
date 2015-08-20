class ProjectsData
  attr_reader :projects

  def initialize
    @projects ||= []
  end

  def add(object)
    return false if find(object.name)
    projects << object
    true
  end

  def rename(old_name, new_name)
    return false unless project = find(old_name)
    project.name = new_name
    true
  end

  def delete(name)
    original_size = projects.size
    projects.delete_if{|project| project.name == name}
    projects.size < original_size
  end

  def find(name)
    projects.detect{|project| project.name == name}
  end

  def size
    projects.size
  end
end
