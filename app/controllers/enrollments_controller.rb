class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  require 'enrollment.rb'

  before_action only: [:destroy] do
    to_root_if_not_at_least(:teacher)
  end

  before_action :check_expire

  def index
    if current_user.nil? or not compare_accesslevel(:teacher)
      redirect_to :root, notice: 'Sivu on vain opettajille.'
    else
      @projectbundle = Projectbundle.find_by_active(true)

      if @projectbundle.nil?
        redirect_to :root, notice: 'Ei aktiivisia projektiryhmiä.'
      else
        @user_is_admin = compare_accesslevel(:admin)
        set_projectbundle_and_projects
        @enrollments = Enrollment.all
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
    if (@activebundle.nil? or not @activebundle.signup_is_active)
      redirect_to :root, notice: 'Yritit ilmottautua projekteihin, joiden ilmottautumisaika on umpeutunut'
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
    end
    redirect_to enrollments_path
  end

  # Checks if link hash is valid and allows editing if that is the case
  def edithash
    @enrollment = Enrollment.find(params[:enrollment_id])
    if @enrollment.nil? or not Enrollment.create_hash(@enrollment) == params[:hash]
      redirect_to :root, notice: 'Ilmoittautumista ei löydy.'
    elsif not (@enrollment.return_projectbundle.signup_is_active)
      redirect_to :root, notice: 'Ilmoittautuminen on päättynyt.'
    else
      session[:enrollment_id] = @enrollment.id
      session[:hash] = params[:hash]

      redirect_to action: 'edit', id: params[:enrollment_id]

    end
  end

  def edit
    redirect_to :root if session[:enrollment_id].nil? or session[:hash].nil? # edithash is not successfully run
    set_projectbundle_and_projects
    @enrollment = Enrollment.find(session[:enrollment_id])
  end

  # creates a new forced signup or destroys an existing forced signup
  def setforced
    enrollment = Enrollment.find params[:enrollment_id]
    new_forced = params[:forced]
    projectbundle = enrollment.projects.first.projectbundle

    # nobody can force while signups are active, only admin when signups are verified
    unless projectbundle.signup_is_active or (projectbundle.verified and not compare_accesslevel(:admin))  or not compare_accesslevel(:teacher)
      if (new_forced == 'true')
        signup = Signup.new(enrollment_id: params[:enrollment_id], project_id: params[:project_id], priority: 10, status: true, forced: true)
        signup.save
      else
        signup = enrollment.signups.find_by_project_id(params[:project_id])
        if signup.forced #only destroy the signup if it was forced. if it is not an error has occurred
          signup.destroy
        end
      end
    end
    render nothing: true

  end

  def setstatus
    enrollment = Enrollment.find params[:enrollment_id]
    projectbundle = enrollment.projects.first.projectbundle

    # nobody can set status while signups are active, only admin when signups are verified
    unless projectbundle.signup_is_active or (projectbundle.verified and not compare_accesslevel(:admin)) or not compare_accesslevel(:teacher)
      signup = enrollment.signups.find_by_project_id(params[:project_id])

      new_status = params[:status]
      signup.status = new_status
      signup.save
    end
    render nothing:true
  end

  # Returns json with all existing signups
  def get_current_statuses
    if compare_accesslevel(:teacher)
      bundle = Projectbundle.includes([{:enrollments => :signups}, {:projects => :signups}]).find_by_active(true)
      enrollments = bundle.enrollments
      signups = bundle.signups
      projects = bundle.projects
      enrollments_json = enrollments.as_json(only: [:id], methods: [:accepted_amount, :magic_number])
      projects_json = projects.as_json(only: [:id, :maxstudents], methods: :amount_of_accepted_students)
      signups_json = signups.as_json( only: [:enrollment_id, :project_id, :status, :forced, :priority])
      response = [enrollments_json, projects_json, signups_json]
      render :json => response
    else
      render nothing:true
    end
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    #@params = params[:enrollment][:signups_attribute]
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

  # Clears session variables after edit
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
