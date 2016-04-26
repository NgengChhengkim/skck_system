class Measure < ActiveRecord::Base
  belongs_to :company

  has_many :unit_of_measures

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  scope :find_measures, ->{includes :unit_of_measures}

  accepts_nested_attributes_for :unit_of_measures,
    reject_if: proc {|attributes| attributes[:name].blank?}, allow_destroy: true
end
