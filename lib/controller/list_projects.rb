module Controller
  class ListProjects < Struct.new(:state, :input, :print)
    def perform
      print.listing_project_header
      print.list(state.projects)
    end
  end
end
