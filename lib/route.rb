class Route < Struct.new(:id, :description, :controller_class)
  def perform(state, input, print)
    controller_class.new(state, input, print).perform
  end
end
