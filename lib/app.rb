require 'forwardable'
require 'json'

require_relative 'state'
require_relative 'project'
require_relative 'null_project'
require_relative 'task'
require_relative 'collection'
require_relative 'persistence'

require_relative 'print'

class App
  attr_reader :input_stream,
    :state, :print

  def initialize(output_stream, input_stream)
    @print = Print.new(output_stream)
    @input_stream = input_stream
    @state = State.new
  end

  def run
    state.load

    print.projects_menu
    command = get_input

    while command != 'q'
      if !current_project?
        case command
        when 'a'
          print.project_name_prompt
          name = get_input
          add_project(name)
          print.project_created(name)
        when 'ls'
          print.listing_project_header
          if projects_empty?
            print.no_projects_message
          else
            projects.each do |project|
              print.project_list_item(project)
            end
            print.break
          end
        when 'd'
          if projects_empty?
            print.cant_delete_project
            print.no_projects_message
          else
            print.project_name_prompt
            project_name = get_input
            if project = delete_project(project_name)
              print.successful_delete(project.name)
            else
              print.project_does_not_exist(project_name)
            end
          end
        when 'e'
          if projects_empty?
            print.cant_edit_project
            print.no_projects_message
          else
            print.project_name_prompt
            name = get_input
            if project = set_current_project(name)
              print.tasks_menu(project.name)
              command = get_input
              next
            else
              print.cant_edit_project
              print.project_does_not_exist(name)
            end
          end
        end
        print.projects_menu
      else
        case command
        when 'a'
          print.task_name_prompt
          task_name = get_input
          add_task(task_name)
          print.created_task(task_name)
        when 'b'
          set_current_project(false)
          print.break
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
          if current_tasks_empty?
            print.no_tasks_created_in(project_name)
          else
            print.task_prompt
            task_name = get_input
            if task = delete_task(task_name)
              print.task_deleted(task.name)
            else
              print.task_does_not_exsit(task_name)
            end
          end
        when 'f'
          project_name = current_project.name
          if current_tasks_empty?
            print.no_tasks_created_in(project_name)
          else
            print.task_name_prompt
            task_name = get_input
            if task = delete_task(task_name)
              print.finished_task(task.name)
            else
              print.task_does_not_exsit(task_name)
            end
          end
        when 'ls'
          if current_tasks_empty?
            print.no_tasks_created_in(current_project.name)
          else
            print.task_list_header
            current_tasks.each do |task|
              print.task_item(task)
            end
            print.break
          end
        end
        print.tasks_menu(current_project.name) if current_project?
      end

      command = get_input
    end
  end

  def get_input
    input_stream.gets.strip
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
