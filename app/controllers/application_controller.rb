class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :check_expire
  helper_method :current_user
  helper_method :to_root_if_not_at_least
  helper_method :compare_accesslevel

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  # Redirects to signin page if user does not have at least given accesslevel
  def to_root_if_not_at_least(level)
    if not current_user.nil?
      list = {:admin => 1, :teacher => 0}
      if list[level] > current_user.accesslevel
        redirect_to signin_path, alert: 'Vain järjestelmävalvojalla on pääsy sivulle' #If logged in but not allowed here, must not be admin
      else
        list[level] <= current_user.accesslevel # returns true...
      end
    else # User is not logged in
      redirect_to signin_path, alert: 'Sinun täytyy kirjautua sisään päästäksesi tarkastelemaan sivua'
    end
  end

  # Returns true if user is logged in and has at the least the given accesslevel, otherwise false
  def compare_accesslevel(accesslevel)
    if not current_user.nil?
      list = {:admin => 1, :teacher => 0}
      list[accesslevel] <= current_user.accesslevel
    else
      false
    end
  end

  def check_expire
    if not session_is_unset
      if session[:timeout] < Time.now
        session[:user_id] = nil
        session[:timeout] = nil
        redirect_to :root, alert: 'Istuntosi on vanhentunut, kirjaudu uudelleen sisään'
        #     render 'signout', method :delete
      else
        session[:timeout] = Time.now + 20.minutes
      end
    end
  end

  def session_is_unset
    session[:timeout].nil? or session[:timeout].nil?
  end
end
