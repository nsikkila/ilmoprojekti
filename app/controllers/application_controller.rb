class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :is_at_least
  helper_method :is_logged_in_and_authored

  def current_user
    return nil if session[:user_id].nil? 
    User.find(session[:user_id]) 
  end

  def is_at_least(level)
  	if not current_user.nil?
  		list = {:admin => 1, :teacher => 0 }
  		list[level] == current_user.accesslevel
    else
      redirect_to :root
	  end
  end

  def is_logged_in_and_authored
    not current_user.nil? and (is_at_least(:admin) or is_at_least(:teacher))
  end
end
