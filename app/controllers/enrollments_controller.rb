class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  require 'enrollment.rb'

  before_action only: [:destroy] do
    to_root_if_not_at_least(:teacher)
  end

  before_action :check_expire

  def index
    if current_user.nil? or not to_root_if_not_at_least(:teacher)
      redirect_to :root, notice: "Sivu on vain opettajille."
    else
      @projectbundle = Projectbundle.find_by_active(true)

      if @projectbundle.nil?
        redirect_to :root, notice: "Ei aktiivisia projektiryhmiä"
      else
        set_projectbundle_and_projects
        @enrollments = Enrollment.all
        @user_is_admin = to_root_if_not_at_least(:admin)
      end
    end
  end

  def new
    if Projectbundle.find_by_active(true).nil?
      @enrollment = nil
    else
      set_projectbundle_and_projects
      @enrollment = Enrollment.new
      set_signups_to_enrollment(6)
    end
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
          EnrollmentMail.confirmation_email(@enrollment, @digest, @activebundle).deliver
          format.html { render action: 'show' }
        else
          set_projectbundle_and_projects
          format.html { render action: 'new' }
        end
      end
    end
  end

  def destroy
    enrollment = Enrollment.find_by_id(params[:enrollment_id])
    if not enrollment.nil?
      Enrollment.destroy(enrollment)
      redirect_to enrollments_path
    else
      redirect_to enrollments_path
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
    if not @enrollment.return_projectbundle.signup_is_active
      redirect_to :root, notice: 'Ilmottautumisen muokkaus ei ole enää mahdollista'
    end
  end

  def setforced
    enrollment = Enrollment.find params[:enrollment_id]
    project = Project.find params[:project_id]
    new_forced = params[:forced]

    unless enrollment.projectbundle.is_signup_active
      if (new_forced == 'true')
        signup = Signup.new(enrollment_id: params[:enrollment_id], project_id: params[:project_id], priority: 0, status: true, forced: true)
        signup.save
      else
        signup = enrollment.signups.find_by_project_id(params[:project_id])
        signup.destroy
      end

      render nothing: true
    end
  end

  def setstatus
    enrollment = Enrollment.find params[:enrollment_id]
    unless enrollment.projects.first.projectbundle.signup_is_active
      signup = enrollment.signups.find_by_project_id(params[:project_id])
      project = signup.project

      new_status = params[:status]
      signup.status = new_status
      signup.save

      render nothing: true
    end
  end

  def huippu
    bundle = Projectbundle.includes(:projects, :signups, :enrollments).find_by_active(true)

    signups = bundle.signups
    enrollments = bundle.enrollments
    projects = bundle.projects
    enrollments_json = enrollments.as_json(only: [:id], methods: [:accepted_amount, :magic_number])
    projects_json = projects.as_json(only: [:id, :maxstudents], methods: :amount_of_accepted_students)
    signups_json = signups.as_json( only: [:enrollment_id, :project_id, :status, :forced, :priority])

    response = [enrollments_json, projects_json, signups_json]
    render :json => response

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

      @enrollment.signups << Signup.new(priority: priority, forced: false)

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
    params.require(:enrollment).permit(:firstname, :lastname, :studentnumber, :email, :signups_attributes => [:project_id, :enrollment_id, :priority, :id, :forced])
  end

end