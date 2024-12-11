require 'rails_helper'

RSpec.describe User, type: :model do

  subject { described_class.new(email: "user@gmail.com", password: "1234!@#", password_confirmation: "1234!@#") }

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
      expect(subject.errors[:password]).to include("must be 10 characters or less and include at least one special character (!@#$%^&*).")
    end
  end
end
