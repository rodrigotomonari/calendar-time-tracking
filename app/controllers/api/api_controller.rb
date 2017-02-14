module Api
  class ApiController < ActionController::Base
    before_action :authenticate_user!

    def authenticate_user!
      return true if user_signed_in?

      render json: {
        status: 'error',
        msg: 'Please login'
      }, status: 403
    end
  end
end
