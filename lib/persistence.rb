class Persistence < Struct.new(:path)
  def load
    JSON.load(File.read(path))
  rescue JSON::ParserError
    []
  end

  def save(hash)
    write(hash.to_json)
  end

  private

  def write(string)
    File.open(path, 'w') {|f| f.write(string) }
  end
end
