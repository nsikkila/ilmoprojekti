class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action only: [:edit, :index, :new, :create, :update, :destroy] do
    is_at_least(:teacher)
  end
  before_action :check_expire

  # GET /projects
  # GET /projects.json
  def index
    @projectbundles = Projectbundle.all
    #@projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    proj = Project.find(params[:id])
    enroll = proj.enrollments
    @emails = ""
    enroll.each do |enr|
      enr.signups.each do |signs|
        if signs.status and signs.project_id == proj.id
          @emails = @emails + enr.email + ","
        end
      end
    end
    @emails

  end

  # GET /projects/new
  def new
    @project = Project.new
    #@project.projectpicture = Projectpicture.new
    @bundle = Projectbundle.all
  end

  # GET /projects/1/edit
  def edit
    #@project = Project.find(params[:project_id])
    #@bundle = @project.projectbundle
    @bundle = Projectbundle.all
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user = current_user

    #return if params[:projectpicture].blank?

    #@projectpicture = @project.projectpicture

    respond_to do |format|
      if @project.save
        @projectpicture = Projectpicture.new

        @projectpicture.uploaded_file = params[:project][:projectpicture]

        if @projectpicture.save
          puts("##########")
          puts(@project.id)
          puts(@projectpicture.id)
          @project.projectpicture = @projectpicture
          @projectpicture.project = @project
        else
          redirect_to :root
        end
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        @bundle = Projectbundle.all
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @bundle = Projectbundle.all
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name, :description, :projectbundle_id, :website, :maxstudents, :projectpicture_attributes => [:projectpicture])
  end
end
