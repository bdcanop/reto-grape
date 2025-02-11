require "rails_helper"

RSpec.describe Product, type: :model do

  before do
    @product = Product.new(name: "Laptop", price: 1500.50, stock: 10)
  end

  context "Validations" do
    it "is valid with valid attributes" do
      expect(@product).to be_valid
    end

    it "is not valid without a name" do
      @product.name = nil
      expect(@product).not_to be_valid
      expect(@product.errors[:name]).to include("can't be blank")
    end

    it "is not valid without a price" do
      @product.price = nil
      expect(@product).not_to be_valid
      expect(@product.errors[:price]).to include("can't be blank")
    end

    it "is not valid if the price is not numeric" do
      @product.price = "abc"
      expect(@product).not_to be_valid
      expect(@product.errors[:price]).to include("is not a number")
    end

    it "is not valid if the price is less than 0" do
      @product.price = -1
      expect(@product).not_to be_valid
      expect(@product.errors[:price]).to include("must be greater than 0")
    end

    it "is not valid without stock" do
      @product.stock = nil
      expect(@product).not_to be_valid
      expect(@product.errors[:stock]).to include("can't be blank")
    end

    it "is not valid if the stock is not numeric" do
      @product.stock = "abc"
      expect(@product).not_to be_valid
      expect(@product.errors[:stock]).to include("is not a number")
    end

    it "is not valid if stock is decimal" do
      @product.stock = 2.5
      expect(@product).not_to be_valid
      expect(@product.errors[:stock]).to include("must be an integer")
    end

    it "is not valid if stock is less than 0" do
      @product.stock = -5
      expect(@product).not_to be_valid
      expect(@product.errors[:stock]).to include("must be greater than or equal to 0")
    end
  end
end