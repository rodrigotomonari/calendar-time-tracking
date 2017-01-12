class HomeController < ApplicationController
  def index
    @user = User.find(params[:user]) if current_user.admin? && params[:user].present? && params[:user].to_i != current_user.id
  end
end
