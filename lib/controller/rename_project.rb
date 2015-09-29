module Controller
  class RenameProject < Struct.new(:state, :input, :print)
    def perform
      print.new_project_name_prompt
      old_name = state.current_project.name
      new_name = input.get
      state.rename_project(old_name, new_name)
      print.changed_project_name(old_name, new_name)
    end
  end
end


