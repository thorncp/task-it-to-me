require_relative 'manifest'

class App
  attr_reader :state, :print, :menu_factory, :input, :command

  def initialize(output_stream, input_stream)
    @print =        Print.new(output_stream)
    @input =        Input.new(input_stream)
    @state =        State.new
    @menu_factory = MenuFactory.new(state)
  end

  def run
    print.prompt_for_username
    state.load(input.get)

    print.welcome_message
    print.projects_menu(menu)

    get_next_command

    while command != 'q'
      route.perform(state, input, print) if route
      print_menu
      get_next_command
    end
  end

  def route
    menu.get(command)
  end

  def get_next_command
    @command = input.get
  end

  def menu
    menu_factory.generate
  end

  def print_menu
    if current_project?
      print.tasks_menu(current_project.name, menu)
    else
      print.projects_menu(menu)
    end
  end

  extend Forwardable

  def_delegators :state,
    :current_project?,
    :current_project
end
