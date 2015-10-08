require_relative '../test_helper'

class TestSigninNewUserController < Minitest::Test
  def controller
    @controller ||= Controller::SigninNewUser.new(state, input, print)
  end

  def state
    @state ||= State.new
  end

  def input
    @input ||= Input.new(StringIO.new(""))
  end

  def print
    @print ||= Print.new(StringIO.new(""))
  end

  def output
    print.output_stream.string
  end

  def stub_input(*inputs)
    input.input_stream.stubs(:gets).returns(*inputs)
  end

  def test_when_state_has_no_username
    stub_input("kane")
    controller.perform
    assert_includes(output, "Enter your username:")
    refute_includes(output, "Signing out of")
    assert_equal('kane', state.username)
  end

  def test_when_state_has_username
    stub_input("kane")
    state.username = 'bertha'
    controller.perform
    assert_includes(output, "Signing out bertha")
    assert_includes(output, "Enter your username:")
    assert_equal('kane', state.username)
  end

  def test_when_states_has_current_project
    stub_input('kane')

    state.username = 'bertha'
    state.add_project('make it go')
    state.set_current_project('make it go')

    controller.perform

    assert_equal(false, state.current_project?)
  end
end



