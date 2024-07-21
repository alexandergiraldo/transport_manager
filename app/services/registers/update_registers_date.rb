module Registers
  class UpdateRegistersDate
    def initialize(document)
      @document = document
    end

    def perform
      @document.registers.each do |register|
        register.update(event_date: @document.event_date) if register.event_date != @document.event_date
      end
    end
  end
end
