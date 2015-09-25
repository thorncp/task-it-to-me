class Menu < Struct.new(:routes)
  def include?(id)
    routes.any?{|route| route.id == id}
  end

  def get(id)
    routes.detect{|route| route.id == id}
  end

  def ids
    routes.map(&:id)
  end

  extend Forwardable

  def_delegators :routes, :size
end
