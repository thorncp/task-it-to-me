module Controller
  class EditProject < Struct.new(:state, :input, :print)
    def perform
      print.project_name_prompt
      name = input.get
      unless project = state.set_current_project(name)
        print.cant_edit_project
        print.project_does_not_exist(name)
      end
    end
  end
end

