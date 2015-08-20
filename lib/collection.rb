class Collection
  attr_reader :collection

  def initialize
    @collection ||= []
  end

  def add(object)
    return false if find(object.name)
    collection << object
    true
  end

  def rename(old_name, new_name)
    return false unless object = find(old_name)
    object.name = new_name
    true
  end

  def delete(name)
    original_size = collection.size
    collection.delete_if{|object| object.name == name}
    collection.size < original_size
  end

  def find(name)
    collection.detect{|object| object.name == name}
  end

  def names
    collection.map(&:name)
  end

  extend Forwardable
  def_delegators :collection, :size, :map, :each
end
