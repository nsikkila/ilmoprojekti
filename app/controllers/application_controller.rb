class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :check_expire
  helper_method :current_user
  helper_method :is_at_least
  helper_method :compare_accesslevel

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def is_at_least(level)
    if not current_user.nil?
      list = {:admin => 1, :teacher => 0}
      if list[level] > current_user.accesslevel #ohjataan käyttäjä roottiin jos ei tarpeeksi iso accesslevel
        redirect_to signin_path, alert: "Vain järjestelmävalvojalla on pääsy sivulle"
      else
        list[level] <= current_user.accesslevel
      end
    else #ohjataan kirjautumaton käyttäjä roottiin
      redirect_to signin_path, alert: "Sinun täytyy kirjautua sisään päästäksesi tarkastelemaan sivua"
    end
  end

  def compare_accesslevel(accesslevel)
    if not current_user.nil?
      list = {:admin => 1, :teacher => 0}
      list[accesslevel] <= current_user.accesslevel
    end
  end

  def check_expire
    if not session_is_unset
      if session[:timeout] < Time.now
        session[:user_id] = nil
        session[:timeout] = nil
        redirect_to :root, alert: "Istuntosi on vanhentunut, kirjaudu uudelleen sisään"
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
