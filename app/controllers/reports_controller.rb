class ReportsController < ApplicationController
  def index

    @results = Task.group('subproject_phases.id, users.id')
                 .includes(:user, subproject_phase: [:phase, subproject: [project: [:client]]])
                 .order('projects.name asc', 'subprojects.name asc', 'phases.name asc', 'users.name asc')
                 .pluck('projects.name', 'subprojects.name', 'phases.name', 'users.name', 'sum(time)', 'subproject_phases.id', 'users.id')
  end
end
