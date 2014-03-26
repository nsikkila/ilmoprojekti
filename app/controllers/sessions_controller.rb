class SessionsController < ApplicationController

  before_action :check_expire

  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    if user.nil? or not user.authenticate params[:password]
      redirect_to signin_path, notice: "Käyttäjätunnus tai salasana ei täsmää"
    else
      session[:user_id] = user.id
      session[:timeout] = Time.now + 20.minutes
      redirect_to user, notice: "Tervetuloa takaisin!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    session[:timeout] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end