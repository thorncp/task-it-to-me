module Controller
  class DeleteProject < Struct.new(:state, :input, :print)
    def perform
      print.project_name_prompt
      project_name = input.get
      if project = state.delete_project(project_name)
        print.successful_delete(project.name)
      else
        print.project_does_not_exist(project_name)
      end
    end
  end
end
