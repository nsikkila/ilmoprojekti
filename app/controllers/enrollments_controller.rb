class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  
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
    #@projects = Project.all
  end

  def create

    @enrollment = Enrollment.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        @digest = create_hash(@enrollment)
        format.html { render action:'show' }
      else
        @projectbundle = Projectbundle.first
        @projects = @projectbundle.projects

        format.html { render action: 'new' }
      end
    end
    @digest=create_hash(@enrollment)
    EnrollmentMail.confirmation_email(@enrollment, @digest).deliver
  end

  # GET enrollments/edit/enrollment_id/hash
  def edit
    @projectbundle = Projectbundle.first
    @projects = @projectbundle.projects
    @enrollment = Enrollment.find(params[:enrollment_id])

    if not params[:hash] == create_hash(@enrollment)
      redirect_to :root
    end
  end

  def update

    @enrollment = Enrollment.find(params[:id])

    respond_to do |format|
      if @enrollment.update(enrollment_params)
        @digest = create_hash(@enrollment)
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
    params.require(:enrollment).permit(:firstname, :lastname, :studentnumber, :email, :signups_attributes => [:project_id, :enrollment_id, :priority])
  end

  

  

end