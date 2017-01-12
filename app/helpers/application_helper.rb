module ApplicationHelper
  def users_list
    @users = User.where('status = ?', 'active').where('id != ?', current_user.id).order(name: :asc)
  end
end
