class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def access_denied(access = nil)
    case current_user.type
    when 'AdminUser'
      redirect_to home_expositions_path
    when 'Expositor'
      redirect_to edit_home_expositor_path(current_user)
    when 'Architect'
      redirect_to home_blueprint_files_path
    when 'Designer'
      redirect_to home_catalogs_path
    else
      redirect_to new_user_session_path(current_user)
    end
  end

  def after_sign_in_path_for resource
    case resource.type
    when 'AdminUser'
      home_expositions_path
    when 'Expositor'
      edit_home_expositor_path(resource)
    when 'Architect'
      home_blueprint_files_path
    when 'Designer'
      home_catalogs_path
    else
      new_user_session_path(resource)
    end
  end

end
