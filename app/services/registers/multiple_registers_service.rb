module Registers
  class MultipleRegistersService
    attr_accessor :errors
    attr_reader :vehicle, :params, :user

    def initialize(params, user, vehicle, current_account)
      @params = params
      @user = user
      @vehicle = vehicle
      @current_account = current_account
      @errors = []
    end

    def process
      return unless valid?
      ActiveRecord::Base.transaction do
        document = create_document_if_present
        registers_list.each do |register|
          next if register[:_destroy] == 'true'
          create_register(register, document)
        end
      end
    rescue Exception => e
      ActiveRecord::Rollback
      self.errors << "Ha ocurrido un error: #{e.message}"
      Rails.logger.info("===> #{e.message} \n #{e.backtrace.join('\n')} \n")
      false
    end

    def registers
      registers_list.map do |register|
        Register.new(
          description: register[:description],
          category: register[:category],
          event_date: register[:event_date],
          value: register[:value],
          vehicle_id: vehicle.id,
          maintainable: register[:maintainable],
          notes: register[:notes],
          register_type: register[:register_type]
        )
      end
    end

    def create_register(register, document = nil)
      register_object = Register.new(
        description: register[:description],
        event_date: register[:event_date],
        register_type: register[:register_type],
        value: Register.sanitize_amount(register[:value]),
        notes: register[:notes],
        vehicle_id: vehicle.id,
        user_id: user.id,
        document_id: document&.id || register[:document_id]
      )
      raise Pundit::NotAuthorizedError.new("Not authorized") unless RegisterPolicy.new(user, register_object).create?
      register_object.save!
      create_maintenance(register, register_object.id) if register[:maintainable] == "1" && register_object.outcoming?
    end

    private

    def valid?
      self.errors << "Invalid parameters" if params[:vehicle].blank? && params[:document].blank?
      self.errors.blank?
    end

    def registers_list
      if params[:document]
        params[:document][:registers_attributes].values
      else
        params[:vehicle][:registers_attributes].values
      end
    end

    def create_document_if_present
      document_params = params[:document]
      if document_params
        document_params[:load_value] = Register.sanitize_amount(document_params[:load_value])
        document = Document.new(document_params.except(:registers_attributes, :commit))
        document.user_id = user.id
        document.vehicle_id = vehicle.id
        document.account_id = @current_account.id
        raise Pundit::NotAuthorizedError.new("Not authorized") unless DocumentPolicy.new(user, document).create?
        document.save!
        document
      end
    end

    def create_maintenance(register, register_id)
      Maintenance.create!(
        description: register[:description],
        category: register[:category],
        event_date: register[:event_date],
        value: register[:value],
        vehicle_id: vehicle.id,
        user_id: user.id,
        register_id: register_id
      )
    end
  end
end