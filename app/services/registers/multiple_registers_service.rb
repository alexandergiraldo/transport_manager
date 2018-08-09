module Registers
  class MultipleRegistersService
    attr_accessor :errors
    attr_reader :vehicle, :params, :user

    def initialize(params, user, vehicle)
      @params = params
      @user = user
      @vehicle = vehicle
      @errors = []
    end

    def process
      return unless valid?
      ActiveRecord::Base.transaction do
        registers_list.each do |register|
          next if register[:_destroy] == 'true'
          create_register(register)
        end
      end
    rescue Exception => e
      ActiveRecord::Rollback
      self.errors << "Ha ocurrido un error: #{e.message}"
      Rails.logger.warn("===> #{e.message} \n #{e.backtrace.join('\n')} \n")
      false
    end

    def registers
      registers_list.map do |register|
        Maintenance.new(
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

    def create_register(register)
      register_object = Register.create!(
        description: register[:description],
        event_date: register[:event_date],
        register_type: register[:register_type].to_i,
        value: register[:value],
        notes: register[:notes],
        vehicle_id: vehicle.id,
        user_id: user.id,
      )
      create_maintenance(register, register_object.id) if register[:maintainable] == "1" && register_object.outcoming?
    end

    private

    def valid?
      self.errors << "Invalid parameters" if params[:vehicle].blank?
      self.errors.blank?
    end

    def registers_list
      params[:vehicle][:registers_attributes].values
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