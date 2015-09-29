module Controller
  class DeleteTask < Struct.new(:state, :input, :print)
    def perform
      task_name = state.current_project.name
      print.task_prompt
      task_name = input.get
      if task = state.delete_task(task_name)
        print.task_deleted(task.name)
      else
        print.task_does_not_exsit(task_name)
      end
    end
  end
end
