class PreloadRegistersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!

  def edit
    @preload_register = PreloadRegister.find(params[:id])
    authorize @preload_register, :update?

    respond_to do |format|
      format.js {
          render  :action => "edit.js.erb",
                  :layout => false
      }
    end
  end

  def update
    @preload_register = PreloadRegister.find(params[:id])
    authorize @preload_register, :update?

    if @preload_register.update(register_sketch_params)
      redirect_to register_sketch_path(@preload_register.register_sketch_id), flash: {success: "Registro Actualizado exitosamente"}
    else
      flash.now[:error] = @preload_register.errors.full_messages.join("<br/>")
      render :new
    end
  end

  def destroy
    @preload_register = PreloadRegister.find(params[:id])
    authorize @preload_register, :update?

    if @preload_register.destroy
      alert = "Registro eliminado exitosamente"
    else
      alert = "Ha ocurrido un error"
    end

    redirect_to register_sketch_path(@preload_register.register_sketch_id), flash: {alert: alert}
  end

  protected

  def register_sketch_params
    params.require(:preload_register).permit(:description, :register_type, :value, :notes)
  end
end