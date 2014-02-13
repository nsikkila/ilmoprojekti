class EnrollmentsController < ApplicationController

  require 'digest/sha1'
  def index
    @Projectbundle = Projectbundle.first
    #@projects = @Projectbundle.projects
    @projects = Project.all
  end

  def create

    @student = Student.create(firstname: params[:sfirstname], lastname: params[:slastname], studentnumber: params[:studentnumber], email: params[:email])
    Signup.create(student_id: @student.id, priority: 1, status: false, project_id: params[:p1][:project_id])
    Signup.create(student_id: @student.id, priority: 2, status: false, project_id: params[:p2][:project_id])
    Signup.create(student_id: @student.id, priority: 3, status: false, project_id: params[:p3][:project_id])
    Signup.create(student_id: @student.id, priority: 4, status: false, project_id: params[:p4][:project_id])
    Signup.create(student_id: @student.id, priority: 5, status: false, project_id: params[:p5][:project_id])
    Signup.create(student_id: @student.id, priority: 6, status: false, project_id: params[:p6][:project_id])
    @signups = @student.signups
    create_hash
    render action:'show'
  end

  # GET enrollments/hash/edit
  def edit
    @Projectbundle = Projectbundle.first
    @projects = Project.all
    @enrollment = Enrollment.new
    @enrollment.msg=params[:hash]
  end

private

  def create_hash
     @digest=Digest::SHA1.hexdigest (@student.id.to_s + @student.studentnumber.to_s)
  end

end