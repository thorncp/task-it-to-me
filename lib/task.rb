class Task < Struct.new(:name, :position)
  def to_hash
    { name: name }
  end
end
