module Maintenances
  class MultipleMaintenancesService
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
        maintenances_list.each do |maintenance|
          next if maintenance[:_destroy] == 'true'
          create_maintenance(maintenance)
        end
      end
    rescue Exception => e
      ActiveRecord::Rollback
      self.errors << "Ha ocurrido un error: #{e.message}"
      Rails.logger.warn("===> #{e.message} \n #{e.backtrace.join('\n')} \n")
      false
    end

    def maintenances
      maintenances_list.map do |maintenance|
        Maintenance.new(
          description: maintenance[:description],
          category: maintenance[:category],
          event_date: maintenance[:event_date],
          value: maintenance[:value],
          vehicle_id: vehicle.id,
          registrable: maintenance[:registrable]
        )
      end
    end

    def create_maintenance(maintenance)
      register = create_register(maintenance) if maintenance[:registrable] == "1"
      record = Maintenance.create!(
                description: maintenance[:description],
                category: maintenance[:category],
                event_date: maintenance[:event_date],
                value: maintenance[:value],
                vehicle_id: vehicle.id,
                user_id: user.id,
                register_id: register.try(:id)
              )
    end

    private
    def valid?
      self.errors << "Invalid parameters" if params[:vehicle].blank?
      self.errors.blank?
    end

    def maintenances_list
      params[:vehicle][:maintenances_attributes].values
    end

    def create_register(maintenance)
      Register.create!(
        description: maintenance[:description],
        event_date: maintenance[:event_date],
        register_type: 1,
        vehicle_id: vehicle.id,
        value: maintenance[:value],
        user_id: user.id,
      )
    end
  end
end