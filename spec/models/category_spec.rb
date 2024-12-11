require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'is valid with a name' do
    category = Category.new(name: 'Electronics')
    expect(category).to be_valid
  end

  it 'is invalid without a name' do
    category = Category.new(name: nil)
    expect(category).to be_invalid
    expect(category.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with a duplicate name' do
    Category.create!(name: 'Electronics')
    category = Category.new(name: 'Electronics')
    expect(category).to be_invalid
    expect(category.errors[:name]).to include('has already been taken')
  end

  it 'creates a valid category' do
    category = Category.create!(name: 'Books')
    expect(category).to be_persisted
  end
end
