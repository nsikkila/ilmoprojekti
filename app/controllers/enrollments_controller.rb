class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  require 'enrollment.rb'
  
  def index
  end

  def new
    @projectbundle = Projectbundle.first
    @projects = @projectbundle.projects
    @enrollment = Enrollment.new

    priority = 1
    6.times do
      @enrollment.signups << Signup.new(priority:priority)
      priority = priority + 1
    end

  end

  def create

    @enrollment = Enrollment.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        @digest = Enrollment.create_hash(@enrollment)
        format.html { render action:'show' }
      else
        @projectbundle = Projectbundle.first
        @projects = @projectbundle.projects
        format.html { render action: 'new' }
      end
    end
    @digest=Enrollment.create_hash(@enrollment)

    EnrollmentMail.confirmation_email(@enrollment, @digest).deliver
  end

  def edithash
    @enrollment = Enrollment.find(params[:enrollment_id])

    if @enrollment.nil? or not params[:hash] == Enrollment.create_hash(@enrollment)
      redirect_to :root
    else

    session[:enrollment_id] = @enrollment.id
    session[:hash] = params[:hash]

    redirect_to action: 'edit', id:params[:enrollment_id]

    end
  end

  def edit

    redirect_to :root if session[:enrollment_id].nil? or session[:hash].nil?

    @projectbundle = Projectbundle.first
    @projects = @projectbundle.projects
    @enrollment = Enrollment.find(session[:enrollment_id])
  end

  def update
    @enrollment = Enrollment.find(params[:id])

    respond_to do |format|
      if @enrollment.update(enrollment_params) and Enrollment.create_hash(@enrollment) == session[:hash]
        @digest = create_hash(@enrollment)
        session[:enrollment_id] = nil
        session[:hash] = nil
        format.html { render action:'show' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def create_hash(enrollment)
     Digest::SHA1.hexdigest (enrollment.id.to_s + enrollment.created_at.to_s)
  end

private

  def enrollment_params
    params.require(:enrollment).permit(:firstname, :lastname, :studentnumber, :email, :signups_attributes => [:project_id, :enrollment_id, :priority, :id])
  end
  
end