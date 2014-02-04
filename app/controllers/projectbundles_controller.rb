class ProjectbundlesController < ApplicationController
  before_action :set_projectbundle, only: [:show, :edit, :update, :destroy]

  # GET /projectbundles
  # GET /projectbundles.json
  def index
    @projectbundles = Projectbundle.all
  end

  # GET /projectbundles/1
  # GET /projectbundles/1.json
  def show
  end

  # GET /projectbundles/new
  def new
    if is_at_least(:teacher)
      @projectbundle = Projectbundle.new
    else
      redirect_to :root
    end
  end

  # GET /projectbundles/1/edit
  def edit
    if not is_at_least(:teacher)
      redirect_to :root
    end
  end

  # POST /projectbundles
  # POST /projectbundles.json
  def create
    if is_at_least(:teacher)
      @projectbundle = Projectbundle.new(projectbundle_params)

      respond_to do |format|
        if @projectbundle.save
          format.html { redirect_to @projectbundle, notice: 'Projectbundle was successfully created.' }
          format.json { render action: 'show', status: :created, location: @projectbundle }
        else
          format.html { render action: 'new' }
          format.json { render json: @projectbundle.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to :root
    end
  end

  # PATCH/PUT /projectbundles/1
  # PATCH/PUT /projectbundles/1.json
  def update
    if is_at_least(:teacher)
      respond_to do |format|
        if @projectbundle.update(projectbundle_params)
          format.html { redirect_to @projectbundle, notice: 'Projectbundle was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @projectbundle.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to :root
    end
  end

  # DELETE /projectbundles/1
  # DELETE /projectbundles/1.json
  def destroy
    if is_at_least(:teacher)
      @projectbundle.destroy
      respond_to do |format|
        format.html { redirect_to projectbundles_url }
        format.json { head :no_content }
      end
    else
      redirect_to :root
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_projectbundle
      @projectbundle = Projectbundle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def projectbundle_params
      params.require(:projectbundle).permit(:name, :description, :active)
    end
end
