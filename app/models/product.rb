class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  def self.ransackable_attributes(auth_object = nil)
    %w[id name price stock created_at updated_at]
  end
end
