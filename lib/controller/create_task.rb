module Controller
  class CreateTask < Struct.new(:state, :input, :print)
    def perform
      print.task_prompt
      task_name = input.get
      state.add_task(task_name)
      print.created_task(task_name)
    end
  end
end
