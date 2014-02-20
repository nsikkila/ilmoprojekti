class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  
  def index
  end

  def new
    @projectbundle = Projectbundle.first
    @projects = @projectbundle.projects
    @enrollment = Enrollment.new

    6.times do
      @enrollment.signups << Signup.new
    end
    #@projects = Project.all
  end

  def create

    @enrollment = Enrollment.new(enrollment_params)
    respond_to do |format|
      if @enrollment.save
        format.html { render action:'show' }
      else
        @projectbundle = Projectbundle.first
        @projects = @projectbundle.projects

        format.html { render action: 'new' }
      end
    end
    @digest=create_hash(@enrollment)
    #EnrollmentMail.confirmation_email(@student, @digest).deliver

  end

  # GET enrollments/edit/student_id/hash
  def edit
    @Projectbundle = Projectbundle.first
    @projects = Project.all
    @enrollment = Enrollment.new

    student = Student.last
    student = Student.find(params[:student_id])

    if params[:hash] == create_hash(student)
      signups = Array.new(6)
      student.signups.each do |s|
        signups[s.priority-1] = s.project_id
      end

      @enrollment.signups = signups
      @enrollment.sfirstname = student.firstname
      @enrollment.slastname = student.lastname
      @enrollment.studentnumber = student.studentnumber
      @enrollment.email = student.email
    else
      redirect_to :root
    end

  end

private

  def enrollment_params
    params.require(:enrollment).permit(:firstname, :lastname, :studentnumber, :email, :signups_attributes => [:project_id, :enrollment_id])
  end

  def create_hash(enrollment)
     Digest::SHA1.hexdigest (enrollment.id.to_s + enrollment.created_at.to_s)
  end

end