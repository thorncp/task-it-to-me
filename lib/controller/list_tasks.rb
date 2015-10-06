module Controller
  class ListTasks < Struct.new(:state, :input, :print)
    def perform
      print.task_list_header
      print.list(state.current_tasks)
      print.finished_task_list(state.finished_tasks)
    end
  end
end


