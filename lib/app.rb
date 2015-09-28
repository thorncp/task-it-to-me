require 'forwardable'
require 'json'

require_relative 'state'
require_relative 'project'
require_relative 'null_project'
require_relative 'task'
require_relative 'collection'
require_relative 'persistence'

require_relative 'formatter'
require_relative 'print'

require_relative 'menu_factory'
require_relative 'menu'
require_relative 'route'

class App
  attr_reader :input_stream,
    :state, :print, :menu_factory

  def initialize(output_stream, input_stream)
    @print =        Print.new(output_stream)
    @input_stream = input_stream
    @state =        State.new
    @menu_factory = MenuFactory.new(state)
  end

  def run
    state.load

    print.welcome_message
    print.projects_menu(menu)

    command = get_input

    while command != 'q'
      if !menu.include?(command)
        command = get_input
        next
      end

      do_command(command)
      print_menu
      command = get_input
    end
  end

  def get_input
    input_stream.gets.strip
  end

  def menu
    menu_factory.generate
  end

  def do_command(command)
    if current_project?
      do_task_command(command)
    else
      do_project_command(command)
    end
  end

  def print_menu
    if current_project?
      print.tasks_menu(current_project.name, menu)
    else
      print.projects_menu(menu)
    end
  end

  def do_project_command(command)
    case command
    when 'a'
      print.project_name_prompt
      name = get_input
      add_project(name)
      print.project_created(name)
    when 'ls'
      print.listing_project_header
      print.list(projects)
    when 'd'
      print.project_name_prompt
      project_name = get_input
      if project = delete_project(project_name)
        print.successful_delete(project.name)
      else
        print.project_does_not_exist(project_name)
      end
    when 'e'
      print.project_name_prompt
      name = get_input
      if project = set_current_project(name)
        print.tasks_menu(project.name, menu)
      else
        print.cant_edit_project
        print.project_does_not_exist(name)
      end
    end
  end

  def do_task_command(command)
    case command
    when 'a'
      print.task_prompt
      task_name = get_input
      add_task(task_name)
      print.created_task(task_name)
    when 'b'
      set_current_project(false)
    when 'c'
      print.new_project_name_prompt
      old_name = current_project.name
      new_name = get_input
      rename_project(old_name, new_name)
      print.changed_project_name(old_name, new_name)
    when 'e'
      name = get_input
      if task = find_task(name)
        old_name = task.name
        print.editing_task(old_name)
        print.task_prompt
        new_name = get_input
        rename_task(old_name, new_name)
        print.changed_task_name(old_name, new_name)
      else
        print.task_does_not_exsit(name)
      end
    when 'd'
      project_name = current_project.name
      print.task_prompt
      task_name = get_input
      if task = delete_task(task_name)
        print.task_deleted(task.name)
      else
        print.task_does_not_exsit(task_name)
      end
    when 'f'
      project_name = current_project.name
      print.task_prompt
      task_name = get_input
      if task = delete_task(task_name)
        print.finished_task(task.name)
      else
        print.task_does_not_exsit(task_name)
      end
    when 'ls'
      print.task_list_header
      print.list(current_tasks)
    end
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
    :find_task
end
