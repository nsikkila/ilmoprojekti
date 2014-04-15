class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action only: [:edit, :index, :new, :create, :update, :destroy] do
    to_root_if_not_at_least(:teacher)
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
    @projectbundles = Projectbundle.all
  end

  # GET /projects/1/edit
  def edit
    if @project.user == current_user or compare_accesslevel(:admin)
      @projectbundles = Projectbundle.all
    else
      redirect_to projects_path, notice: 'Voit muokata vain omia projektejasi.'
    end

  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user = current_user

    #return if params[:projectpicture].blank?

    #@projectpicture = @project.projectpicture

    respond_to do |format|
      if @project.valid?
        if not params[:project][:projectpicture].nil?
          @projectpicture = Projectpicture.new

          @projectpicture.uploaded_file = params[:project][:projectpicture]

          if @projectpicture.save
            @project.projectpicture = @projectpicture
            @projectpicture.project = @project
            @projectpicture.save
          else
            @projectbundles = Projectbundle.all
            #@project.errors[''] << "Hahaa, loins!"
            render :new, :notice => "Kuvan tallentaminen ei onnistunut."
            return
          end
        end

        @project.save
        format.html { redirect_to @project, notice: 'Projekti onnistuneesti luotu.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        @projectbundles = Projectbundle.all
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.user == current_user or compare_accesslevel(:admin)

      @projectbundles = Projectbundle.all
      respond_to do |format|

        @project.assign_attributes(project_params)

        if @project.valid?

          @projectpicture = Projectpicture.find_by_project_id(@project.id)

          if not params[:project][:projectpicture].nil?

            #Jos updatessa tulee uusi kuva, poistetaan vanha
            if not @projectpicture.nil?
              @projectpicture.destroy
            end

            @projectpicture = Projectpicture.new
            @projectpicture.uploaded_file = params[:project][:projectpicture]

            if @projectpicture.save
              @project.projectpicture = @projectpicture
              @projectpicture.project = @project
              @projectpicture.save
            else
              @projectbundles = Projectbundle.all
              render :edit, :notice => "Nönnönnöö"
              return
            end

          end
          @project.save
          format.html { redirect_to @project, notice: 'Projekti onnistuneesti päivitetty.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if @project.user == current_user or compare_accesslevel(:admin)

      @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_url }
        format.json { head :no_content }
      end
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
