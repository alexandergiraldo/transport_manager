class AddPositionToPreloadRegister < ActiveRecord::Migration[6.1]
  def change
    add_column :preload_registers, :position, :integer

    RegisterSketch.all.each do |sketch|
      sketch.preload_registers.order(:id).each.with_index(1) do |register, index|
        register.update_column :position, index
      end
    end
  end
end
