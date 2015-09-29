module Controller
  class RenameTask < Struct.new(:state, :input, :print)
    def perform
      name = input.get
      if task = state.find_task(name)
        old_name = task.name
        print.editing_task(old_name)
        print.task_prompt
        new_name = input.get
        state.rename_task(old_name, new_name)
        print.changed_task_name(old_name, new_name)
      else
        print.task_does_not_exsit(name)
      end
    end
  end
end


