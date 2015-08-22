require_relative 'test_helper'

class TestAppRun < Minitest::Test
  def app
    @app ||= App.new(stdout, stdin)
  end

  def stdin
    @stdin ||= StringIO.new("")
  end

  def stdout
    @stdout ||= StringIO.new("")
  end

  def output
    stdout.string.gsub(/#{"\e"}\[[0-9;]*m/, '')
  end

  def stub_input(*args)
    args = args.map{|a| "#{a}\n" }
    stdin.stubs(:gets).returns(*args)
  end

  def setup
    stdin.stubs(:gets).returns("q")
  end

  # HELPERS and setup above here ^^^
  # TESTS below here ---------------

  def test_getting_input_until_quit_message
    stdin.expects(:gets).times(2).returns('ls', 'q')
    app.run
  end

  def test_app_welcome_message
    app.run
    assert_includes output, "Welcome to Taskitome!"
  end

  def test_app_initial_message
    app.run
    assert_includes output, "a   Add a new project"
    assert_includes output, "ls  List all project"
    assert_includes output, "d   Delete a project"
    assert_includes output, "e   Edit a project"
    assert_includes output, "q   Quit the app"
  end

  def test_listing_with_empty_projects
    stub_input('ls', 'q')
    app.run
    assert_includes output, "No projects created"
  end

  def test_adding_project
    stub_input('a', 'Cat Husbandry', 'q')
    app.run
    assert_includes output, "Enter a project name"
    assert_includes output, "Created project: 'Cat Husbandry'"
  end

  def test_listing_non_empty_projects
    stub_input('a', 'Cat Servitude', 'a', 'House work', 'ls', 'q')
    app.run
    assert_includes output, "Listing projects:\n  1.  Cat Servitude\n  2.  House work"
  end

  def test_delete_projects_when_projects_empty
    stub_input('d', 'q')
    app.run
    assert_includes output, "No projects created"
    assert_includes output, "Can't delete a project"
  end

  def test_delete_project_when_project_exists
    stub_input('a', 'House work', 'd', 'House work', 'ls', 'q')
    app.run
    last_section = output.split("Listing projects").last
    assert_includes output, "Deleting project: 'House work'"
    refute_includes last_section, "House work"
    assert_includes last_section, "No projects created"
  end

  def test_delete_project_by_position
    stub_input('a', 'House work', 'd', '1', 'ls', 'q')
    app.run
    last_section = output.split("Listing projects").last
    assert_includes output, "Deleting project: 'House work'"
    refute_includes last_section, "House work"
    assert_includes last_section, "No projects created"
  end

  def test_delete_project_that_does_not_exist
    stub_input('a', 'House work', 'd', 'House Work', 'q')
    app.run
    refute_includes output, "Deleting project: 'House Work'"
    assert_includes output, "Project doesn't exist: 'House Work'"
  end

  def test_edit_project_when_projects_does_not_exist
    stub_input('e', 'q')
    app.run
    assert_includes output, "No projects created"
    assert_includes output, "Can't edit any projects"
  end

  def test_edit_project_that_does_not_exist
    stub_input('a', 'House work', 'e', 'House Work', 'q')
    app.run
    refute_includes output, "Editing project: 'House Work'"
    assert_includes output, "Project doesn't exist: 'House Work'"
  end

  def test_editing_existing_project_shows_project_menu
    stub_input('a', 'House work', 'e', 'House work', 'q')
    app.run
    assert_includes output, "c   Change the project name"
    assert_includes output, "a   Add a new task"
    assert_includes output, "ls  List all tasks"
    assert_includes output, "d   Delete a task"
    assert_includes output, "e   Edit a task"
    assert_includes output, "f   Finish a task"
    assert_includes output, "b   Back to Projects menu"
  end

  def test_edit_project_by_position_number
    stub_input('a', 'House work', 'e', '1', 'q')
    app.run
    assert_includes output, "Editing project: 'House work'"
    assert_includes output, "c   Change the project name"
  end

  def test_changing_project_name
    stub_input('a', 'House work', 'e', 'House work', 'c', 'Chores', 'b', 'ls', 'q')
    app.run
    last_section = output.split("Listing projects").last
    assert_includes output, "Changed project name from 'House work' to 'Chores'"
    refute_includes last_section, "House work"
    assert_includes last_section, "Chores"
  end

  def test_adding_a_task
    stub_input('a', 'House work', 'e', 'House work', 'a', 'clean out the freezer', 'q');
    app.run
    assert_includes output, "Enter a task name"
    assert_includes output, "Created task: 'clean out the freezer'"
  end

  def test_listing_tasks_when_project_has_none
    stub_input('a', 'House work', 'e', 'House work', 'ls', 'q')
    app.run
    assert_includes output, "No tasks created in 'House work'"
  end

  def test_listing_a_task_after_adding_a_task
    stub_input('a', 'House work', 'e', 'House work', 'a', 'clean out the freezer', 'ls', 'q');
    app.run
    last_section = output.split("Listing tasks").last
    assert_includes last_section, "1.  clean out the freezer"
  end

  def test_editing_a_task_that_does_not_exist
    stub_input('a', 'House work', 'e', 'House work', 'e', 'clean out the freezer', 'q')
    app.run
    assert_includes output, "Task doesn't exist: 'clean out the freezer'"
  end

  def test_editing_a_task_that_does_exist
    stub_input('a', 'House work', 'e', 'House work', 'a', 'clean out the freezer', 'e', 'clean out the freezer', 'clean out fridge', 'ls', 'q')
    app.run
    assert_includes output, "Changed task name from 'clean out the freezer' to 'clean out fridge'"
    last_section = output.split("Listing tasks").last
    refute_includes last_section, "clean out the freezer"
    assert_includes last_section, "clean out fridge"
  end

  def test_delete_task_when_no_tasks
    stub_input('a', 'House work', 'e', 'House work', 'd', 'clean out the freezer', 'q')
    app.run
    assert_includes output, "No tasks created in 'House work'"
  end

  def test_delete_task_when_task_doesnt_exist
    stub_input('a', 'House work', 'e', 'House work', 'a', 'clean out the freezer', 'd', 'eat defrosting food', 'q')
    app.run
    assert_includes output, "Task doesn't exist: 'eat defrosting food'"
  end

  def test_delete_task_that_exists
    stub_input('a', 'House work', 'e', 'House work', 'a', 'clean out the freezer', 'd', 'clean out the freezer', 'ls', 'q')
    app.run
    assert_includes output, "No tasks created in 'House work'"
    assert_includes output, "Deleted task: 'clean out the freezer'"
  end

  def test_finish_task_when_no_tasks
    stub_input('a', 'House work', 'e', 'House work', 'f', 'clean out the freezer', 'q')
    app.run
    assert_includes output, "No tasks created in 'House work'"
  end

  def test_finish_task_when_task_doesnt_exist
    stub_input('a', 'House work', 'e', 'House work', 'a', 'clean out the freezer', 'f', 'eat defrosting food', 'q')
    app.run
    assert_includes output, "Task doesn't exist: 'eat defrosting food'"
  end

  def test_finish_task_that_exists
    stub_input('a', 'House work', 'e', 'House work', 'a', 'clean out the freezer', 'f', 'clean out the freezer', 'ls', 'q')
    app.run
    assert_includes output, "Finished task: 'clean out the freezer'"
    assert_includes output, "No tasks created in 'House work'"
  end

  def test_bug_app_should_not_unexpectedly_quit
    stub_input('e', 'a', 'new project', 'q')
    app.run
    assert_includes output, "Created project:"
  end

  def test_bug_commands_with_space_unrecognized
    stub_input('a ', 'new project', 'q')
    app.run
    assert_includes output, "Created project:"
  end
end


