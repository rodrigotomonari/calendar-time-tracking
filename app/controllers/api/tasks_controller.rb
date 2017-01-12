module Api
  class TasksController < ActionController::Base
    def index
      @tasks = Task.includes(subproject_phase: [:phase, subproject: [project: [:client]]])
                 .where(user_id: current_user.id)
                 .where('started_at >= ?', params[:start])
                 .where('ended_at <= ?', params[:end])
    end

    def create
      @task = Task.new({
                            user_id:             current_user.id,
                            subproject_phase_id: params[:subproject_phase_id],
                            started_at:          params[:start],
                            ended_at:            params[:end],
                            request_control:     0
                          })
      if @task.save
        render json: {
          status: 'ok',
          task:   {
            id: @task.id
          }, status: :created
        }
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def update
      @task = Task.find(params[:id])
      if @task && @task.request_control.to_i < params[:request_control].to_i
        @task.started_at      = params[:start]
        @task.ended_at        = params[:end]
        @task.request_control = params[:control]
        @task.save!

        render json: {
          status: 'ok'
        }
      end
    end

    def destroy
      @task = Task.destroy(params[:id])
      render json: {
        status: 'ok'
      }
    end
  end
end
