class Persistence
  def load
  end

  def save(hash)
    write(hash.to_json)
  end

  def path
    File.expand_path(File.dirname(__FILE__) + "/../data/projects.json")
  end

  private

  def write(string)
    File.open(path, 'w') {|f| f.write(string) }
  end
end
