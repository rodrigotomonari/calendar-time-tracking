class PhasesController < ApplicationController
  before_action :set_phase, only: %i[show edit update destroy]

  # GET /phases
  # GET /phases.json
  def index
    @phases = Phase.order(name: :asc)
  end

  # GET /phases/1
  # GET /phases/1.json
  def show; end

  # GET /phases/new
  def new
    @phase = Phase.new
  end

  # GET /phases/1/edit
  def edit; end

  # POST /phases
  # POST /phases.json
  def create
    @phase = Phase.new(phase_params)

    respond_to do |format|
      if @phase.save
        format.html { redirect_to phases_url, notice: t('flash_messages.phases.created') }
        format.json { render :show, status: :created, location: @phase }
      else
        format.html { render :new }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phases/1
  # PATCH/PUT /phases/1.json
  def update
    respond_to do |format|
      if @phase.update(phase_params)
        format.html { redirect_to phases_url, notice: t('flash_messages.phases.updated') }
        format.json { render :show, status: :ok, location: @phase }
      else
        format.html { render :edit }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phases/1
  # DELETE /phases/1.json
  def destroy
    @phase.destroy
    respond_to do |format|
      format.html { redirect_to phases_url, notice: t('flash_messages.phases.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_phase
    @phase = Phase.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def phase_params
    params.require(:phase).permit(:name)
  end
end
