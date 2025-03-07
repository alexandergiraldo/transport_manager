require 'rails_helper'

RSpec.describe Register, type: :model do
  describe "Associations" do
    it { should belong_to(:vehicle) }
    it { should belong_to(:user) }
    it { should belong_to(:document).optional }
    it { should have_one(:maintenance).dependent(:destroy) }
  end

  describe "Validations" do
    it { should validate_presence_of(:register_type) }
  end

  describe "Scopes" do
    it "should have a scope by_date" do
      expect(Register.by_date).to eq(Register.order('event_date ASC'))
    end
  end

  describe "Delegations" do
    it { should delegate_method(:license_plate).to(:vehicle).with_prefix }
  end

  describe "Class Methods" do
    describe "#search" do
      it "should return the result of the query" do
        params = { q: { description_cont: "test" } }
        query = Register.includes(:vehicle).ransack(params[:q])
        expect(Register.search(params)).to eq(query.result)
      end
    end

    describe "#sanitize_amount" do
      it "should return the amount without special characters" do
        amount = "R$ 1.000,00"
        expect(Register.sanitize_amount(amount)).to eq("100000")
      end
    end

    describe "#preload_registers" do
      it "should return an array of registers" do
        register_sketch = double("register_sketch", preload_registers: [double("register", description: "test", register_type: "incoming", value: 1000, notes: "test")])
        registers = Register.preload_registers(register_sketch)
        expect(registers.first.description).to eq("test")
        expect(registers.first.register_type).to eq("incoming")
        expect(registers.first.value).to eq(1000)
        expect(registers.first.notes).to eq("test")
      end
    end
  end
end
