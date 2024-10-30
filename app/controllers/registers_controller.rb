class RegistersController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :init_date_params, only: [:index]

  content_security_policy only: [:index, :new] do |policy|
    policy.style_src :self, :unsafe_inline, 'https://cdn.jsdelivr.net', 'https://cdnjs.cloudflare.com'
  end

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
    if @document || params.dig(:register_sketch, :id).present?
      @register_sketch = RegisterSketch.find_by(id: params.dig(:register_sketch, :id))
      registers_list = Register.preload_registers(@register_sketch)
      @registers = registers_list if registers_list.present?
    end
  end

  def create
    @register_service = ::Registers::MultipleRegistersService.new(params.to_unsafe_h, current_user, current_vehicle, current_account)

    if @register_service.process
      target_date = @register_service.registers.last.event_date
      redirect_to registers_path(open_document: params[:document_id], event_start: "#{target_date.year}-#{sprintf('%02d', target_date.month)}"), flash: {success: "Registros creados exitosamente"}
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
    @register.maintainable = @register.maintenance ? "1" : "0"
    @register.category = @register.maintenance&.maintenance_type_id

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
        event_start: "#{@register.event_date.year}-#{sprintf('%02d', @register.event_date.month)}"
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

  def delete_multiple
    ids = params.require(:register_ids).split(",")
    @registers = Register.where(id: ids)
    @registers = authorized_registers_to_delete

    if Register.destroy(@registers.map(&:id))
      redirect_to request.referer, flash: {alert: "Registros eliminados exitosamente"}
    else
      redirect_to request.referer, flash: {alert: "Error al eliminar los registros"}
    end
  end

  protected

  def register_params
    r_params = params.require(:register).permit(:description, :category, :register_type, :notes, :event_date, :value, :vehicle_id, :maintainable, :document_id)
    r_params[:value] = Register.sanitize_amount(r_params[:value])
    r_params
  end

  def authorized_registers_to_delete
    @registers.each { |register| authorize(register, :destroy?) }
  end
end