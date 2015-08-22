require 'forwardable'

require_relative 'state'
require_relative 'project'
require_relative 'null_project'
require_relative 'task'
require_relative 'collection'

class App
  attr_reader :input_stream, :output_stream,
    :state

  def initialize(output_stream, input_stream)
    @output_stream = output_stream
    @input_stream = input_stream
    @state = State.new
  end

  def run
    print_projects_menu

    command = get_input

    while command != 'q'
      if !current_project?
        case command
        when 'a'
          print_project_name_prompt
          name = get_input
          add_project(name)
          print_project_created(name)
        when 'ls'
          print_listing_project_header
          if projects_empty?
            print_no_projects_message
          else
            projects.each do |project|
              print_project_list_item(project)
            end
            print_break
          end
        when 'd'
          if projects_empty?
            print_cant_delete_project
            print_no_projects_message
          else
            print_project_name_prompt
            project_name = get_input
            if project = find_project(project_name)
              delete_project(project_name)
              print_successful_delete(project.name)
            else
              print_project_does_not_exist(project_name)
            end
          end
        when 'e'
          if projects_empty?
            print_cant_edit_project
            print_no_projects_message
          else
            print_project_name_prompt
            name = get_input
            if set_current_project(name)
              print_tasks_menu(find_project(name))
              command = get_input
              next
            else
              print_cant_edit_project
              print_project_does_not_exist(name)
            end
          end
        end
      else
        case command
        when 'a'
          print_task_name_prompt
          task_name = get_input
          add_task(task_name)
          print_created_task(task_name)
        when 'b'
          set_current_project(false)
          print_break
        when 'c'
          print_new_project_name_prompt
          old_name = current_project.name
          new_name = get_input
          rename_project(old_name, new_name)
          print_changed_project_name(old_name, new_name)
        when 'e'
          name = get_input
          if task_exists?(name)
            print_editing_task(name)
            print_task_prompt
            new_name = get_input
            rename_task(name, new_name)
            print_changed_task_name(name, new_name)
          else
            print_task_does_not_exsit(name)
          end
        when 'd'
          project_name = current_project.name
          if current_tasks_empty?
            print_no_tasks_created_in(project_name)
          else
            print_task_prompt
            task_name = get_input
            if delete_task(task_name)
              print_task_deleted(task_name)
            else
              print_task_does_not_exsit(task_name)
            end
          end
        when 'f'
          project_name = current_project.name
          if current_tasks_empty?
            print_no_tasks_created_in(project_name)
          else
            print_task_name_prompt
            task_name = get_input
            if delete_task(task_name)
              print_finished_task(task_name)
            else
              print_task_does_not_exsit(task_name)
            end
          end
        when 'ls'
          if current_tasks_empty?
            print_no_tasks_created_in(current_project.name)
          else
            print_task_list_header
            current_tasks.each do |task|
              print_task_item(task)
            end
            print_break
          end
        end
      end

      command = get_input
    end
  end

  def get_input
    input_stream.gets.strip
  end

  def print_line(message='')
    output_stream.puts(message)
  end

  # Menu Headers

  def print_projects_menu
    print_line("\e[38;5;40mWelcome to Taskitome!")
    print_line("\e[0;37m=============================\n")
    print_line("\e[0mPROJECTS MENU")
    print_line("\e[0;37m-----------------------------")
    print_line("\e[40;38;5;214mENTER A COMMAND:\e[0m")
    print_line("\e[1;37ma   \e[0;35mAdd a new project")
    print_line("\e[1;37mls  \e[0;35mList all project")
    print_line("\e[1;37md   \e[0;35mDelete a project")
    print_line("\e[1;37me   \e[0;35mEdit a project")
    print_line("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")
  end

  def print_tasks_menu(project)
    print_line("\e[38;5;40mEditing project: '#{project.name}'\n\n")
    print_line("\e[0;37mEDIT PROJECT MENU\e[0m")
    print_line("-----------------------------")
    print_line("\e[40;38;5;214mENTER A COMMAND:\e[0m")
    print_line("\e[1;37mc   \e[0;35mChange the project name")
    print_line("\e[1;37ma   \e[0;35mAdd a new task")
    print_line("\e[1;37mls  \e[0;35mList all tasks")
    print_line("\e[1;37md   \e[0;35mDelete a task")
    print_line("\e[1;37me   \e[0;35mEdit a task")
    print_line("\e[1;37mf   \e[0;35mFinish a task")
    print_line("\e[1;37mb   \e[0;35mBack to Projects menu")
    print_line("\e[1;37mq   \e[0;35mQuit the app\e[0m\n\n")
  end

  # Assorted printing/view methods
  def print_break
    print_line("\n\n")
  end

  # project menu related messages, no arguments required
  def print_no_projects_message
    print_line("\e[40;38;5;214mNo projects created\e[0m\n\n")
  end

  def print_project_name_prompt
    print_line("\e[0;3mEnter a project name:\e[0m")
  end

  def print_new_project_name_prompt
    print_line("\e[0;35mEnter new project name:\e[0m")
  end

  def print_listing_project_header
    print_line("\e[38;5;40mListing projects:\e[0m\n")
  end

  def print_cant_delete_project
    print_line("\e[40;38;5;214mCan't delete a project\e[0m")
  end

  def print_cant_edit_project
    print_line("\e[40;38;5;214mCan't edit any projects\e[0m")
  end

  # project menu related messages, with data passed in
  def print_project_created(name)
    print_line("\e[38;5;40mCreated project:\e[0m '#{name}'\n\n")
  end

  def print_project_list_item(project)
    print_line("  #{project.position}.  \e[0;35m#{project.name}\e[0m\n")
  end

  def print_successful_delete(name)
    print_line "\e[38;5;40mDeleting project:\e[0m '#{name}'\n\n"
  end

  def print_project_does_not_exist(name)
    print_line "\e[40;38;5;214mProject doesn't exist:\e[0m '#{name}'\n\n"
  end

  # task menu related messages, no data passed in
  def print_task_name_prompt
    print_line("\e[0;35mEnter a task name:\e[0m")
  end

  def print_task_list_header
    print_line("\e[38;5;40mListing tasks:\e[0m")
  end

  # task menu related messages, data required

  def print_created_task(name)
    print_line("\e[38;5;40mCreated task:\e[0m '#{name}'\n\n")
  end

  def print_changed_project_name(old_name, new_name)
    print_line("\e[38;5;40mChanged project name from\e[0m '#{old_name}' \e[38;5;40mto\e[0m '#{new_name}'\n\n")
  end

  def print_editing_task(name)
    print_line("\e[38;5;40mEditing task:\e[0m '#{name}'")
  end

  def print_task_prompt
    print_line("\e[0;35mEnter a task name:\e[0m")
  end

  def print_changed_task_name(old_name, new_name)
    print_line("\e[38;5;40mChanged task name from\e[0m '#{old_name}' \e[38;5;40mto\e[0m '#{new_name}'\n\n")
  end

  def print_task_does_not_exsit(name)
    print_line("\e[40;38;5;214mTask doesn't exist:\e[0m '#{name}'\n\n")
  end

  def print_no_tasks_created_in(project_name)
    print_line("\e[40;38;5;214mNo tasks created in '#{project_name}'\e[0m\n\n")
  end

  def print_task_deleted(name)
    print_line("\e[38;5;40mDeleted task:\e[0m '#{name}'\n\n")
  end

  def print_finished_task(name)
    print_line("\e[38;5;40mFinished task:\e[0m '#{name}'\n\n")
  end

  def print_task_item(task)
    print_line("  #{task.position}.  \e[0;35m#{task.name}\e[0m")
  end

  extend Forwardable

  def_delegators :state,
    :projects,
    :add_project,
    :delete_project,
    :rename_project,
    :find_project,
    :projects_empty?,

    :set_current_project,
    :current_project?,
    :current_project,

    :current_tasks,
    :current_tasks_empty?,
    :add_task,
    :delete_task,
    :rename_task,
    :task_exists?
end
