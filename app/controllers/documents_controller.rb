class DocumentsController < ApplicationController
    before_action :authenticate_user!
    before_action :init_date_params, only: [:export]

    content_security_policy only: [:index, :new, :edit, :update] do |policy|
      policy.style_src :self, :unsafe_inline, 'https://cdn.jsdelivr.net', 'https://cdnjs.cloudflare.com', 'https://fonts.googleapis.com'
    end

    def index
      @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).by_date
    end

    def new
      @document = Document.new
      @register_sketch = RegisterSketch.find_by(id: params.dig(:register_sketch, :id))
      @preload_registers = Register.preload_registers(@register_sketch)
      @registers = @preload_registers.presence || @document.registers.new(value: nil)
    end

    def show
      @document = Document.find(params[:id])
    end

    def create
      @register_service = ::Registers::MultipleRegistersService.new(params.to_unsafe_h, current_user, current_vehicle, current_account)

      if @register_service.process
        target_date = @register_service.registers.last.event_date
        redirect_to registers_path(event_start: "#{target_date.year}-#{sprintf('%02d', target_date.month)}"), flash: {success: "Documento creado exitosamente"}
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
        Registers::UpdateRegistersDate.new(@document).perform if params[:document][:apply_date_to_registers] == "1"

        redirect_to root_path(event_start: "#{@document.event_date.year}-#{sprintf('%02d', @document.event_date.month)}"), flash: {success: "Documento actualizado exitosamente"}
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

      redirect_to root_path(event_start: "#{@document.event_date.year}-#{sprintf('%02d', @document.event_date.month)}"), flash: {alert: alert}
    end

    def export
      @documents = policy_scope(Document).where(vehicle_id: current_vehicle.id).search(params).includes(:driver).by_date
      respond_to do |format|
        format.xlsx {
          response.headers['Content-Disposition'] = "attachment; filename=Liquidacion-#{current_vehicle.license_plate}.xlsx"
        }
      end
    end

    def document_params
      d_params = params.require(:document).permit(:title, :driver_id, :event_date, :description, :company, :load_type, :load_value, :load_size, :load_manifest, :driver_advance, :company_advance, :advance_responsible, :balance_in_favor, :balance_in_favor_of, :pending_company_amount, :pending_company_amount_paid, :paid_date, :retentions, :from_latitude, :from_longitude, :to_latitude, :to_longitude)
      d_params[:load_value] = Register.sanitize_amount(d_params[:load_value])
      d_params[:driver_advance] = Register.sanitize_amount(d_params[:driver_advance])
      d_params[:company_advance] = Register.sanitize_amount(d_params[:company_advance])
      d_params[:balance_in_favor] = Register.sanitize_amount(d_params[:balance_in_favor])
      d_params[:pending_company_amount] = Register.sanitize_amount(d_params[:pending_company_amount])
      d_params[:pending_company_amount_paid] = Register.sanitize_amount(d_params[:pending_company_amount_paid])
      d_params[:retentions] = Register.sanitize_amount(d_params[:retentions])
      d_params
    end
  end