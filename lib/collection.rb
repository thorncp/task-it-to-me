class Collection
  attr_reader :collection

  def initialize
    @collection ||= []
  end

  def add(object)
    return false if find(object.name)
    collection << object
    reorder
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
    reorder
    collection.size < original_size
  end

  def find(name)
    return unless name
    find_by_name(name) || find_by_position(name)
  end

  def names
    collection.map(&:name)
  end

  extend Forwardable
  def_delegators :collection, :size, :map, :each

  private

  def find_by_name(name)
    collection.detect{|object| object.name == name}
  end

  def find_by_position(position)
    position = position.to_i
    collection.detect{|object| object.position == position}
  end

  def reorder
    collection.each.with_index do |object, index|
      object.position = index + 1
    end
  end
end
