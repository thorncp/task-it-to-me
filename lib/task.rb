class Task < Struct.new(:name, :position)
  def to_hash
    { name: name }
  end

  def self.load(data)
    new(data['name'])
  end
end
