class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.joins(:client).order(name: :asc)

    @projects = @projects.where('projects.name like ?', "%#{params[:name]}%") if params[:name].present?

    @projects = @projects.where('clients.name like ?', "%#{params[:client]}%") if params[:client].present?

    @projects = @projects.where('projects.status = ?', params[:status]) if params[:status].present?
  end

  # GET /projects/1
  # GET /projects/1.json
  def show; end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_path(@project), notice: 'Projeto criado com sucesso!' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to edit_project_path(@project), notice: 'Projeto atualizado com sucesso!' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Projeto removido com sucesso!' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(
      :id, :name, :client_id, :color, :color_border, :status,
      subprojects_attributes: [
        :id,
        :name,
        :total_estimated_hours,
        :status,
        :_destroy,
        subproject_phases_attributes: %i[
          id
          phase_id
          estimated_hours
          _destroy
        ]
      ]
    )
  end
end
