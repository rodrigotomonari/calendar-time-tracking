class HomeController < ApplicationController
  def index
    @projects = Project.order('name')

  end
end
