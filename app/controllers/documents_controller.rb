class DocumentsController < ApplicationController
    before_action :authenticate_user!

    def index
      @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).by_date
    end

    def new
      @document = Document.new
    end

    def show
      @document = Document.find(params[:id])
    end

    def create
      @register_service = ::Registers::MultipleRegistersService.new(params.to_unsafe_h, current_user, current_vehicle)

      if @register_service.process
        redirect_to registers_path, flash: {success: "Documento creado exitosamente"}
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
        redirect_to root_path, flash: {success: "Documento actualizado exitosamente"}
      else
        render :new, flash: {alert: "Error actualizando"}
      end
    end

    def destroy
      @document = Document.find(params[:id])
      authorize @document, :update?

      if @document.destroy
        redirect_to root_path, flash: {alert: "Documento eliminado exitosamente"}
      else
        redirect_to root_path, flash: {alert: "Ha ocurrido un error"}
      end
    end

    def document_params
      params.require(:document).permit(:title, :event_date, :description, :company, :load_type)
    end
  end