class DocumentsController < ApplicationController
    before_action :authenticate_user!

    def index
      @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).by_date
    end

    def new
      @document = Document.new
      @register_sketch = RegisterSketch.find_by(id: params.dig(:register_sketch, :id))
      @preload_registers = Register.preload_registers(@register_sketch)
      @registers = @preload_registers.presence || @document.registers.new
    end

    def show
      @document = Document.find(params[:id])
    end

    def create
      @register_service = ::Registers::MultipleRegistersService.new(params.to_unsafe_h, current_user, current_vehicle, current_account)

      if @register_service.process
        target_date = @register_service.registers.last.event_date
        redirect_to registers_path(q: {event_date_gteq: target_date.month}, year: target_date.year), flash: {success: "Documento creado exitosamente"}
      else
        flash[:error] = @register_service.errors.join("<br/>")
        @document = Document.new(document_params)
        render :new
      end
    end

    def edit
      @document = Document.find(params[:id])
      authorize @document, :update?
    end

    def update
      @document = Document.find(params[:id])
      authorize @document, :update?

      if @document.update(document_params)
        redirect_to root_path(q: {event_date_gteq: @document.event_date.month}, year: @document.event_date.year), flash: {success: "Documento actualizado exitosamente"}
      else
        render :edit, flash: {alert: "Error actualizando"}
      end
    end

    def destroy
      @document = Document.find(params[:id])
      authorize @document, :update?

      if @document.destroy
        alert = "Documento eliminado exitosamente"
      else
        alert = "Ha ocurrido un error"
      end

      redirect_to root_path(q: {event_date_gteq: @document.event_date.month}, year: @document.event_date.year), flash: {alert: alert}
    end

    def document_params
      params.require(:document).permit(:title, :event_date, :description, :company, :load_type, :load_value, :load_size, :load_manifest)
    end
  end