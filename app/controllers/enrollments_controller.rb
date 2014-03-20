class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  require 'enrollment.rb'

  def index
    if current_user.nil? or not is_at_least(:teacher)
      redirect_to :root, notice: "Sivu on vain opettajille."
    else
      @projectbundle = Projectbundle.find_by_active(true)


      if not @projectbundle.is_signup_active
        set_projectbundle_and_projects
        @enrollments = Enrollment.all
      else
        redirect_to :root, notice: "Ei voimassaolevaa projektiryhmää."
      end
    end
  end

  def new
    set_projectbundle_and_projects
    @enrollment = Enrollment.new
    set_signups_to_enrollment(6)
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    @activebundle = Projectbundle.find_by_active(true)
    if not @activebundle.is_signup_active
      redirect_to :back, notice: 'Yritit ilmottautua projekteihin, joiden ilmottautumisaika on umpeutunut'
    else
      @enrollment.signups.each do |signup|
      signup.status = false
      end
      respond_to do |format|
        if @enrollment.save
          @digest = Enrollment.create_hash(@enrollment)
          EnrollmentMail.confirmation_email(@enrollment, @digest, @projectbundle).deliver
          format.html { render action: 'show' }
        else
          set_projectbundle_and_projects
          format.html { render action: 'new' }
        end
      end
    end
  end

  def edithash
    @enrollment = Enrollment.find(params[:enrollment_id])
    if @enrollment.nil? or not Enrollment.create_hash(@enrollment) == params[:hash]
      redirect_to :root
    else

      session[:enrollment_id] = @enrollment.id
      session[:hash] = params[:hash]

      redirect_to action: 'edit', id: params[:enrollment_id]

    end
  end

  def edit
    redirect_to :root if session[:enrollment_id].nil? or session[:hash].nil?
    set_projectbundle_and_projects
    @enrollment = Enrollment.find(session[:enrollment_id])
    if not @enrollment.return_projectbundle.is_signup_active
     redirect_to :root, notice: 'Ilmottautumisen muokkaus ei ole enää mahdollista'
    end
  end

  def setstatus
    enrollment = Enrollment.find params[:enrollment_id]
    signup = enrollment.signups.find_by_project_id(params[:project_id])
    project = signup.project

    new_status = params[:status]
    signup.status = new_status
    signup.save

    render :json => "{\"acceptedProjects\":\"#{enrollment.accepted_amount}\", \"magicNumber\":\"#{enrollment.compute_magic_number}\", \"acceptedStudents\":\"#{project.amount_of_accepted_students}\", \"maxStudents\":\"#{project.maxstudents}\", \"newStatus\":\"#{signup.status}\"}"
  end

  def getstatus
    enrollment = Enrollment.find(params[:enrollment_id])
    signup = enrollment.signups.find_by_project_id(params[:project_id])
    status = signup.status

    render :json => "{\"currentStatus\":\"#{status}\"}"
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    @params = params[:enrollment][:signups_attribute]
    @digest = Enrollment.create_hash(@enrollment)
    if session_variables_are_valid
      respond_to do |format|
        if @enrollment.update(enrollment_params)
          clear_session_variables
          format.html { render action: 'show' }
        else
          set_projectbundle_and_projects
          format.html { render action: 'edit' }
        end
      end
    else
      redirect_to :root
    end
  end

  def show_emails
    @proj = Project.find(params[:format])
    render :emails
  end

  private

  def set_signups_to_enrollment(number_of_signups)
    priority = 1
    number_of_signups.times do
      @enrollment.signups << Signup.new(priority: priority)
      priority = priority + 1
    end
  end

  def clear_session_variables
    session[:enrollment_id] = nil
    session[:hash] = nil
  end

  def session_variables_are_valid
    session[:hash] == Enrollment.create_hash(@enrollment) and session[:enrollment_id] = @enrollment.id
  end

  def set_projectbundle_and_projects
    @projectbundle = Projectbundle.find_by_active(true)
    @projects = @projectbundle.projects
  end

  def enrollment_params
    params.require(:enrollment).permit(:firstname, :lastname, :studentnumber, :email, :signups_attributes => [:project_id, :enrollment_id, :priority, :id])
  end

end