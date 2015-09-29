module Controller
  class CreateProject < Struct.new(:state, :input, :print)
    def perform
      print.project_name_prompt
      name = input.get
      state.add_project(name)
      print.project_created(name)
    end
  end
end
