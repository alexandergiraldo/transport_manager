class MaintenanceType < ApplicationRecord
  DEFAULT_TYPES = ["Motor", "Caja de Cambios", "Aceite Motor", "Llantas", "Pastillas", "Bujias", "Instalación de Alta", "Bandas", "Bomba", "Amortiguadores", "Rótulas", "Tijeras", "Correa Dentada", "Puntas Ejes", "Axiales", "Manguera de Agua", "Lamina y Pintura", "Carroceria", "Tapicería", "Batería", "Alineación y Balanceo", "Equipo Comunicaciones", "Bombillos", "Cluch", "Frenos", "Radiador", "Extintor", "Sistema de Gas"]

  belongs_to :account

  scope :by_name, -> { order('name ASC') }

end
