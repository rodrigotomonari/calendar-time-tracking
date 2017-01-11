module Api
  class TasksController < ActionController::Base
    def index
      @tasks = Task.includes(subproject_phase: [:phase, subproject: [:project]])
                 .where(user_id: current_user.id)
                 .where('started_at >= ?', params[:start])
                 .where('ended_at <= ?', params[:end])
    end

    def create
      @task = Task.create({
                            user_id:             current_user.id,
                            subproject_phase_id: params[:subproject_phase_id],
                            started_at:          params[:start],
                            ended_at:            params[:end]
                          })
      if @task
        render json: {
          status: 'ok',
          task:   {
            id: @task.id
          }
        }
      else
        render json: {
          status: 'error'
        }
      end
    end

    def update
      @task = Task.find(params[:id])
      if @task && @task.request_control < params[:request_control].to_i
        @task.started_at      = params[:start]
        @task.ended_at        = params[:end]
        @task.request_control = params[:control]
        if @task.save
          render json: {
            status: 'ok'
          }
        else
          render json: {
            status: 'error'
          }
        end
      else
        render json: {
          status: 'error'
        }
      end
    end

    def destroy
      @task = Task.find(params[:id])
      @task.delete
    end
  end
end
