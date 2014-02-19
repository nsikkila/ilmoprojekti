class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  
  def index
  end

  def new
    @projectbundle = Projectbundle.first
    @projects = @projectbundle.projects
    @enrollment = Enrollment.new
    #@projects = Project.all
  end

  def create

    @enrollment = Enrollment.new(enrollment_params)

    @enrollment.save

=begin
    Signup.create(student_id: @student.id, priority: 1, status: false, project_id: params[:p1][:project_id])
    Signup.create(student_id: @student.id, priority: 2, status: false, project_id: params[:p2][:project_id])
    Signup.create(student_id: @student.id, priority: 3, status: false, project_id: params[:p3][:project_id])
    Signup.create(student_id: @student.id, priority: 4, status: false, project_id: params[:p4][:project_id])
    Signup.create(student_id: @student.id, priority: 5, status: false, project_id: params[:p5][:project_id])
    Signup.create(student_id: @student.id, priority: 6, status: false, project_id: params[:p6][:project_id])
    @digest=create_hash(@student)
    EnrollmentMail.confirmation_email(@student, @digest).deliver
=end
    render action:'show'

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
    params.require(:enrollment).permit(:firstname, :lastname, :studentnumber, :email)
  end

  def create_hash(student)
     Digest::SHA1.hexdigest (student.id.to_s + student.studentnumber.to_s)
  end

end