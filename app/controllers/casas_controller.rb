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

  def create


    @student = Student.create(firstname: params[:sfirstname], lastname: params[:slastname], studentnumber: params[:studentnumber], email: params[:email])
    Signup.create(student_id: @student.id, priority: 1, status: "pending", project_id: params[:p1][:project_id])
    Signup.create(student_id: @student.id, priority: 2, status: "pending", project_id: params[:p2][:project_id])
    Signup.create(student_id: @student.id, priority: 3, status: "pending", project_id: params[:p3][:project_id])
    Signup.create(student_id: @student.id, priority: 4, status: "pending", project_id: params[:p4][:project_id])
    Signup.create(student_id: @student.id, priority: 5, status: "pending", project_id: params[:p5][:project_id])
    Signup.create(student_id: @student.id, priority: 6, status: "pending", project_id: params[:p6][:project_id])
    @signups = @student.signups
    render action:'show'
  end

end