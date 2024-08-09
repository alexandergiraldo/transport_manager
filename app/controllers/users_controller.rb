class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = policy_scope(User).account_user
  end

  def new
    @user = User.new
    authorize @user, :create?
  end

  def create
    @user = User.new(user_params)
    @user.vehicle_ids = user_params[:vehicle_ids].reject(&:empty?)
    @user.account_id = current_account_id
    authorize @user, :create?

    if @user.save
      @user.accounts << Account.find(@user.account_id)
      redirect_to users_path, flash: {success: "Usuario creado exitosamente"}
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize @user, :update?
  end

  def update
    @user = User.find(params[:id])
    authorize @user, :update?
    attrs = user_params.clone
    attrs[:vehicle_ids] = attrs[:vehicle_ids].reject(&:empty?)

    if attrs[:password].blank? ? @user.update_without_password(attrs) : @user.update(attrs)
      redirect_to users_path, flash: {success: "Usuario actualizado exitosamente"}
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user, :destroy?

    if @user.destroy
      redirect_to users_path, flash: {alert: "Usuario eliminado exitosamente"}
    else
      redirect_to users_path, flash: {alert: "Error eliminando usuario"}
    end
  end


  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, vehicle_ids: [])
  end
end
