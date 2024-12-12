require 'rails_helper'
RSpec.describe Seller, type: :model do
  subject { described_class.new(email: "seller@gmail.com", password: "1234!@#", password_confirmation: "1234!@#") }
  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a valid password" do
      subject.password = "short"
      expect(subject).not_to be_valid
    end
  end
end
