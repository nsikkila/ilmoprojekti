class CasasController < ApplicationController

  def index
    @Projectbundle = Projectbundle.first
    @projects = Project.all
    @signup = Signup.new
    @signup2 = Signup.new
    @signup3 = Signup.new
    @signup4 = Signup.new
    @signup5 = Signup.new
    @signup6 = Signup.new
  end
end