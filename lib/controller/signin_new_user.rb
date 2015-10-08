module Controller
  class SigninNewUser < Struct.new(:state, :input, :print)
    def perform
      if state.username
        print.signing_out(state.username)
        state.username = nil
        state.set_current_project(nil)
      end
      print.prompt_for_username
      state.load(input.get)
    end
  end
end


