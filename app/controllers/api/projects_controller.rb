module Api
  class ProjectsController < ActionController::Base
    def fancytree
      @projects = Project.includes(:client, subprojects: [subproject_phases: [:phase]])
                    .order('projects.name', 'subprojects.name', 'phases.name asc')

      if params[:status] == 'open'
        @projects = @projects.where('projects.status = ?', 'active').where('subprojects.status = ?', 'active')
      elsif params[:status] == 'recents'
        subproject_phase_ids = Task.select(:subproject_phase_id)
                                 .distinct.where(user_id: current_user.id).limit(10).order(id: :desc)
                                 .pluck(:subproject_phase_id)

        @projects = @projects.where('subproject_phases.id' => subproject_phase_ids)
      else
        render 'fancytree-closed'
      end
    end
  end
end
