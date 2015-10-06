module Controller
  class FinishTask < Struct.new(:state, :input, :print)
    def perform
      task_name = state.current_project.name
      print.task_prompt
      task_name = input.get
      if task = state.finish_task(task_name)
        print.finished_task(task.name)
      else
        print.task_does_not_exsit(task_name)
      end
    end
  end
end
