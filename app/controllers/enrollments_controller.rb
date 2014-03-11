class EnrollmentsController < ApplicationController
  require 'digest/sha1'
  require 'enrollment.rb'

  def index
    if current_user.nil? or not is_at_least(:teacher)
      redirect_to :root
    end
    set_projectbundle_and_projects
    @enrollments = Enrollment.all
  end

  def new
    set_projectbundle_and_projects
    @enrollment = Enrollment.new
    set_signups_to_enrollment(6)
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    delete_empty_signups(@enrollment)
    respond_to do |format|
      if @enrollment.save
        @digest = Enrollment.create_hash(@enrollment)
        EnrollmentMail.confirmation_email(@enrollment, @digest).deliver
        format.html { render action: 'show' }
      else
        set_projectbundle_and_projects
        format.html { render action: 'new' }
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
#    @projects = set_editable_projects(:enrollment_id)
  end

  def toggle
    enrollment = Enrollment.find params[:enrollment_id]
    signup = enrollment.signups.find_by_project_id(params[:project_id])
    project = signup.project
    if signup.status
      signup.status = false
      signup.save
    else
      signup.status = true
      signup.save
    end

    render :json => "{\"acceptedProjects\":\"#{enrollment.accepted_amount}\", \"magicNumber\":\"#{enrollment.compute_magic_number}\", \"acceptedStudents\":\"#{project.amount_of_accepted_students}\", \"maxStudents\":\"#{project.maxstudents}\", \"newStatus\":\"#{signup.status}\"}"
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    # raise params.inspect
    #  @signups = params.select(:signup_attributes)
    @params = params[:enrollment][:signups_attributes]
    db_delete_empty_signups(@params)
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
    @projectbundle = Projectbundle.first
    @projects = @projectbundle.projects
  end

  def enrollment_params
    params.require(:enrollment).permit(:firstname, :lastname, :studentnumber, :email, :signups_attributes => [:project_id, :enrollment_id, :priority, :id])
  end

  def delete_empty_signups(enrollment)
    i=-1
    enrollment.signups.map! { |sign|
      if sign.project_id.blank?
        sign.project_id = i
        i=i-1
      end

    }

#    enrollment.signups.keep_if {|sign| not sign.project_id.blank?}
  end

  def db_delete_empty_signups(prms)
    prms.each do |para|
      i=-1
      para.each do |sign|
        raise sign.last[:project_id].inspect
        vittu = sign[:project_id].last

        vittu = i

        i=i-1
        #   raise i.inspect
      end
    end
  end
end