module Controller
  class Back < Struct.new(:state, :input, :print)
    def perform
      state.set_current_project(false)
    end
  end
end

