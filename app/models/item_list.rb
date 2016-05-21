class ItemList < ActiveRecord::Base
  belongs_to :chart_of_account
  belongs_to :income_account, class_name: "ChartOfAccount"
  belongs_to :cogs_account, class_name: "ChartOfAccount"

  belongs_to :company
  belongs_to :customer_vender
  belongs_to :item_list_type
  belongs_to :unit_of_measure

  has_many :invoice_transactions

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  scope :select_data, ->{includes(:item_list_type, :unit_of_measure)}

  delegate :name, :id, to: :item_list_type, prefix: true, allow_nil: true
  delegate :name, to: :chart_of_account, prefix: true, allow_nil: true
  delegate :name, :id, to: :customer_vender, prefix: true, allow_nil: true
  delegate :name, :id, to: :unit_of_measure, prefix: true, allow_nil: true

  scope :find_data, ->{includes(:item_list_type, :chart_of_account).order("item_list_types.name ASC")}
end
