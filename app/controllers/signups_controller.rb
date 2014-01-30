class SignupsController < ApplicationController
  before_action :set_signup, only: [:show, :edit, :update, :destroy]

  # GET /signups
  # GET /signups.json
  def index
    if is_logged_in_and_authored
      @signups = Signup.all
    else
      redirect :root
    end
  end

  # GET /signups/1
  # GET /signups/1.json
  def show
    if not is_logged_in_and_authored
      redirect_to :root
    end
  end

  # GET /signups/new
  def new
    @signup = Signup.new
  end

  # GET /signups/1/edit
  def edit
    if not is_logged_in_and_authored
        redirect :root
    end
  end

  # POST /signups
  # POST /signups.json
  def create
    @signup = Signup.new(signup_params)
    respond_to do |format|
      if @signup.save
        format.html { redirect_to @signup, notice: 'Signup was successfully created.' }
        format.json { render action: 'show', status: :created, location: @signup }
      else
        format.html { render action: 'new' }
        format.json { render json: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signups/1
  # PATCH/PUT /signups/1.json
  def update
    if is_logged_in_and_authored
      respond_to do |format|
        if @signup.update(signup_params)
          format.html { redirect_to @signup, notice: 'Signup was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @signup.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to :root
    end
  end
  # DELETE /signups/1
  # DELETE /signups/1.json
  def destroy
    if is_logged_in_and_authored
      @signup.destroy
      respond_to do |format|
        format.html { redirect_to signups_url }
        format.json { head :no_content }
      end
    else
      redirect_to :root
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signup
      @signup = Signup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signup_params
      params.require(:signup).permit(:student_id, :project_id)
    end
end
