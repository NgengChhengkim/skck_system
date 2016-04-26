class UnitOfMeasure < ActiveRecord::Base
  belongs_to :measure
  belongs_to :company

  has_many :invoice_transactions
  has_many :item_lists

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
