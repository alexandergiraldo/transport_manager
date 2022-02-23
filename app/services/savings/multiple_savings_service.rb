module Savings
  class MultipleSavingsService
    attr_accessor :errors
    attr_reader :params, :user

    def initialize(params, user)
      @params = params
      @user = user
      @errors = []
    end

    def process
      return unless valid?
      ActiveRecord::Base.transaction do
        savings_list.each do |saving|
          next if saving[:_destroy] == 'true'
          create_saving(saving)
        end
      end
    rescue Exception => e
      ActiveRecord::Rollback
      self.errors << "Ha ocurrido un error: #{e.message}"
      Rails.logger.warn("===> #{e.message} \n #{e.backtrace.join('\n')} \n")
      false
    end

    def create_saving(saving)
      register_object = Saving.create!(
        driver_id: params[:driver_id],
        event_date: saving[:event_date],
        amount: saving[:amount]&.delete('^0-9'),
        notes: saving[:notes],
        vehicle_id: saving[:vehicle_id],
        user_id: user.id,
      )
    end

    private

    def valid?
      self.errors << "Invalid parameters" if params[:driver_id].blank?
      self.errors << "Action not allowed" unless SavingPolicy.new(user, Saving.new(driver_id: params[:driver_id])).create?
      self.errors.blank?
    end

    def savings_list
      params[:driver][:savings_attributes].values
    end
  end
end