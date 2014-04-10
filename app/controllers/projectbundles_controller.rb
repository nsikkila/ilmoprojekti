class ProjectbundlesController < ApplicationController
  before_action :set_projectbundle, only: [:show, :edit, :update, :destroy]
  before_action only: [:edit, :new, :create, :update, :destroy] do
    to_root_if_not_at_least(:teacher)
  end
  before_action only: [:verify] do
    to_root_if_not_at_least(:admin)
  end

  before_action :check_expire
  # GET /projectbundles
  # GET /projectbundles.json
  def index
    @projectbundles = Projectbundle.all.order(created_at: :desc)
    @projectbundle = Projectbundle.find_by_active(true)
    if not @projectbundle.nil?
      respond_to do |format|
        format.html
        format.xlsx
      end
    end
  end

  # GET /projectbundles/1
  # GET /projectbundles/1.json
  def show
  end

  # GET /projectbundles/new
  def new
    @projectbundle = Projectbundle.new
  end

  # GET /projectbundles/1/edit
  def edit
  end

  # POST /projectbundles
  # POST /projectbundles.json
  def create
    @projectbundle = Projectbundle.new(projectbundle_params)
    @projectbundle.verified = false
    respond_to do |format|
      if @projectbundle.save
        format.html { redirect_to @projectbundle, notice: 'Projektiryhmä onnistuneesti luotu.' }
        format.json { render action: 'show', status: :created, location: @projectbundle }
      else
        format.html { render action: 'new' }
        format.json { render json: @projectbundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projectbundles/1
  # PATCH/PUT /projectbundles/1.json
  def update
    respond_to do |format|
      if @projectbundle.update(projectbundle_params)
        format.html { redirect_to @projectbundle, notice: 'Projektiryhmä päivitetty onnistuneesti.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @projectbundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projectbundles/1
  # DELETE /projectbundles/1.json
  def destroy
    @projectbundle.destroy
    respond_to do |format|
      format.html { redirect_to projectbundles_url }
      format.json { head :no_content }
    end
  end

  #Verifioi koko projectbundlen hyväksytyksi -> ryhmäjako lukkiutuu
  def verify
    @projectbundle = Projectbundle.find_by_active(true)

    if (@projectbundle.signup_end < Date.today)
      @projectbundle.verified = true
      @projectbundle.save
      @enrollments = @projectbundle.enrollments
      if not (@enrollments.nil? or @enrollments.empty?)
        EnrollmentMail.result_email_for_all(@enrollments).deliver
      end
      redirect_to projectbundles_path, notice: 'Projektiryhmä vahvistettu!'
    else
      redirect_to projectbundles_path, alert: 'Vahvistaminen peruttu: projektiryhmän ilmoittautuminen ei ole vielä umpeutunut'
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_projectbundle
    @projectbundle = Projectbundle.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def projectbundle_params
    params.require(:projectbundle).permit(:name, :description, :active, :signup_start, :signup_end)
  end

  def is_somebody_active
    is_it_active = false
    @projectbundles.each do |projectbundle|
      if projectbundle.active = true
        is_it_active = true
      end
      return is_it_active
    end
  end
end
