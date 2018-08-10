module Registers
  class ImportFromExcel
    attr_reader :vehicle, :file_name, :user, :errors

    def initialize(file_name, vehicle_plate, user_email)
      @file_name = file_name
      @user ||= User.find_by(email: user_email)
      @vehicle ||= Vehicle.find_by(license_plate: vehicle_plate)
      @errors = []
    end

    def process
      xlsx = Roo::Spreadsheet.open("#{file_name}.xlsx")
      ActiveRecord::Base.transaction do
        1.upto(xlsx.sheets.count-2).each do |sheet_number|
          sheet = xlsx.sheet(sheet_number)
          i = 9
          while sheet.cell('C', i).present?
            i+=1 and next if sheet.cell('D', i).blank? || sheet.cell('D', i).downcase.include?('cierre ')
            register = {}
            register[:event_date] = sheet.cell('C', i)
            register[:description] = sheet.cell('D', i)
            register[:register_type] =  if sheet.cell('E', i).present?
                                          0
                                        elsif sheet.cell('F', i).present?
                                          1
                                        else
                                          0
                                        end
            register[:value] = sheet.cell('E', i).presence || sheet.cell('F', i).presence

            create_register(register)
            i+=1
          end
        end
      end
    rescue Exception => e
      ActiveRecord::Rollback
      self.errors << "Ha ocurrido un error: #{e.message}"
      Rails.logger.warn("===> #{e.message} \n #{e.backtrace.join('\n')} \n")
      false
    end

    def create_register(register)
      register_object = Register.create!(
        description: register[:description],
        event_date: register[:event_date],
        register_type: register[:register_type],
        value: register[:value].to_i,
        notes: register[:notes],
        vehicle_id: vehicle.id,
        user_id: user.id,
      )
    end

  end
end
