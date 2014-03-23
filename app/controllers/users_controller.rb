class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :create, :destroy, :index] do
    is_at_least(:admin)
  end
  before_action only: [:show, :edit, :update] do
     current_user.id == params[:id].to_i or is_at_least(:admin)
  end

  # GET /users
  # GET /users.json
  def index
      @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new  
  def new
      @user = User.new
  end

  # GET /users/1/edit
  def edit
    if current_user.id == params[:id].to_i
      @users = current_user
    elsif is_at_least(:admin)
      @users = User.all
    else
      redirect_to :root
    end

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.accesslevel=0;

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user.id == params[:id].to_i
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to :root
    end

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username,:firstname, :lastname, :password, :password_confirmation, :accesslevel)
    end
end
