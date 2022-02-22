class RegistersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :init_date_params, only: [:index]

  def index
    @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).search(params).includes(registers: [:vehicle]).by_date
    @pagy, @registers = pagy(policy_scope(Register).where(vehicle_id: current_vehicle.id, document_id: nil).search(params).by_date, items: 60)
  end

  def print
    @registers = policy_scope(Register).where(vehicle_id: current_vehicle.id).search(params).by_date
  end

  def new
    @document = Document.find_by(id: params[:document_id])
    @registers = current_vehicle.registers.new(value: nil)
    if @document
      @register_sketch = RegisterSketch.find_by(id: params.dig(:register_sketch, :id))
      registers_list = Register.preload_registers(@register_sketch)
      @registers = registers_list if registers_list.present?
    end
  end

  def create
    @register_service = ::Registers::MultipleRegistersService.new(params.to_unsafe_h, current_user, current_vehicle, current_account)

    if @register_service.process
      target_date = @register_service.registers.last.event_date
      redirect_to registers_path(open_document: params[:document_id], q: {event_date_gteq: target_date.month}, year: target_date.year), flash: {success: "Registros creados exitosamente"}
    else
      flash.now[:error] = @register_service.errors.join("<br/>")
      @document = Document.find_by(id: params[:document_id])
      render :new
    end
  end

  def edit
    @register = Register.find(params[:id])
    params[:q] = { event_date_gteq: @register.event_date.beginning_of_month, event_date_lteq: @register.event_date.end_of_month }
    @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).search(params).by_date

    respond_to do |format|
      format.js {
          render  :action => "edit.js.erb",
                  :layout => false
      }
    end
  end

  def update
    @register = Register.find(params[:id])
    authorize @register, :update?

    if @register.update(register_params)
      redirect_to registers_path(
        open_document: @register.document_id,
        q: {event_date_gteq: @register.event_date.month},
        year: @register.event_date.year
      ), flash: {success: "Registro actualizado exitosamente"}
    else
      render :new
    end
  end

  def destroy
    @register = Register.find(params[:id])
    authorize @register, :update?

    if @register.destroy
      redirect_to request.referer, flash: {alert: "Registro eliminado exitosamente"}
    else
      render :new
    end
  end

  protected

  def register_params
    r_params = params.require(:register).permit(:description, :category, :register_type, :notes, :event_date, :value, :vehicle_id, :maintainable, :document_id)
    r_params[:value] = r_params[:value]&.delete('^0-9')
    r_params
  end
end