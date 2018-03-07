class ReportsController < ApplicationController
  before_action :set_form_data

  def index
    @group_by = ['subproject_phases.id', 'users.id']
    @order_by = ['projects.name asc', 'subprojects.name asc', 'phases.name asc', 'users.name asc']
    @select   = ['projects.name', 'subprojects.name', 'phases.name', 'users.name', 'sum(time)']

    get_results
  end

  def clients
    @group_by = ['clients.id']
    @order_by = ['clients.name asc']
    @select   = ['clients.name', 'sum(time)']

    get_results
  end

  def projects
    @group_by = ['projects.id']
    @order_by = ['projects.name asc']
    @select   = ['projects.name', 'sum(time)']

    get_results
  end

  def subprojects
    @group_by = ['subprojects.id']
    @order_by = ['projects.name asc', 'subprojects.name asc']
    @select   = ['projects.name', 'subprojects.name', 'sum(time)']

    get_results
  end

  def users
    @group_by = ['users.id']
    @order_by = ['users.name asc']
    @select   = ['users.name', 'sum(time)']

    get_results
  end

  def projects_users
    @group_by = ['projects.id', 'users.id', 'year(started_at)', 'month(started_at)']
    @order_by = ['year(started_at) asc', 'month(started_at) asc', 'users.name asc', 'projects.name asc']
    @select   = ['projects.name', 'users.name', 'sum(time)', 'year(started_at)', 'month(started_at)', 'started_at']

    @results = Task.includes(:user, subproject_phase: [:phase, subproject: [project: [:client]]])
                   .group(@group_by)
                   .order(@order_by)

    @results = @results.where('year(tasks.started_at) = ?', params[:year]) if params[:year].present?
    @results = @results.where('month(tasks.started_at) = ?', params[:month]) if params[:month].present?
    @results = @results.where('users.id = ?', params[:user]) if params[:user].present?

    @results = @results.pluck(@select.join(', '))

    @report = Hash.new do |hash, key|
      users = Hash.new do |user, user_key|
        user[user_key] = []
      end
      hash[key] = users
    end

    @results.each do |result|
      year = result[3]
      month = result[4].to_s.rjust(2, '0')
      user = result[1]

      @report["#{year}-#{month}-01"][user].push(
        name: result[0],
        time: result[2]
      )
    end
  end

  private

  def get_results
    if params[:group_month].present?
      @select   += ['year(started_at)', 'month(started_at)']
      @group_by += ['year(started_at)', 'month(started_at)']
      @order_by += ['started_at asc']
    end

    @results = Task.includes(:user, subproject_phase: [:phase, subproject: [project: [:client]]])
                   .group(@group_by)
                   .order(@order_by)

    @results = @results.where('year(tasks.started_at) = ?', params[:year]) if params[:year].present?
    @results = @results.where('month(tasks.started_at) = ?', params[:month]) if params[:month].present?
    @results = @results.where('day(tasks.started_at) = ?', params[:day]) if params[:day].present?
    @results = @results.where('projects.id = ?', params[:project]) if params[:project].present?
    @results = @results.where('subprojects.id = ?', params[:subproject]) if params[:subproject].present?
    @results = @results.where('users.id = ?', params[:user]) if params[:user].present?

    @results = @results.pluck(@select.join(', '))
  end

  def set_form_data
    @years    = Task.pluck('distinct(year(started_at))')
    @months   = (1..12).map { |m| [I18n.l(DateTime.parse(Date::MONTHNAMES[m]), format: '%B'), m] }
    @days     = (1..31).map { |m| [m] }
    @users    = User.order('name asc').map { |u| [u.name, u.id] }
    @projects = Project.order('name asc').map { |p| [p.name, p.id] }

    @subprojects = if params[:project].present?
                     Subproject.order('name asc').where('project_id = ?', params[:project]).map { |p| [p.name, p.id] }
                   else
                     []
                   end
  end
end
