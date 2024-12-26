class RegisterSketchesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!

  content_security_policy only: [:show, :edit] do |policy|
    policy.style_src :self, :unsafe_inline, 'https://cdn.jsdelivr.net', 'https://cdnjs.cloudflare.com'
  end

  def index
    @register_sketches = policy_scope(RegisterSketch)
  end

  def new
    @register_sketch = RegisterSketch.new
  end

  def show
    @register_sketch = RegisterSketch.find(params[:id])
  end

  def create
    @register_sketch = RegisterSketch.new(register_sketch_params)
    @register_sketch.account_id = current_account_id
    authorize @register_sketch, :create?

    if @register_sketch.save
      redirect_to register_sketches_path, flash: {success: "Planilla creada exitosamente"}
    else
      flash.now[:error] = @register_sketch.errors.full_messages.join("<br/>")
      render :new
    end
  end

  def edit
    @register_sketch = RegisterSketch.find(params[:id])
    authorize @register_sketch, :update?
  end

  def update
    @register_sketch = RegisterSketch.find(params[:id])
    authorize @register_sketch, :update?

    if @register_sketch.update(register_sketch_params)
      redirect_to register_sketches_path, flash: {success: "Planilla actualizada exitosamente"}
    else
      flash.now[:error] = @register_sketch.errors.full_messages.join("<br/>")
      render :edit
    end
  end

  def update_registers
    register_ids = preload_registers_params
    @register_sketch = RegisterSketch.find(params[:id])
    authorize @register_sketch, :update?

    preload_registers = @register_sketch.preload_registers.where(id: register_ids)

    register_ids.each_with_index do |register_id, index|
      register = preload_registers.find { |r| r.id == register_id.to_i }
      register.position = index + 1
      register.save! if register.changed?
    end

    respond_to do |format|
      format.json { head :ok }
    end
  end


  def destroy
    @register_sketch = RegisterSketch.find(params[:id])
    authorize @register_sketch, :update?

    if @register_sketch.destroy
      alert = "Planilla borrada exitosamente"
    else
      alert = "Ha ocurrido un error"
    end

    redirect_to register_sketches_path, flash: {alert: alert}
  end

  protected

  def register_sketch_params
    sketch_params = params.require(:register_sketch).permit(:name, preload_registers_attributes: [:id, :name, :description, :register_type, :value, :notes, :register_sketch_id, :account_id, :_destroy])
    sketch_params[:preload_registers_attributes].each do |k, p_register|
      p_register[:value] = Register.sanitize_amount(p_register[:value])
    end
    sketch_params
  end

  def preload_registers_params
    params.require(:register_ids)
  end
end