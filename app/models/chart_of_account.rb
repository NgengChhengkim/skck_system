class ChartOfAccount < ActiveRecord::Base
  belongs_to :chart_account_type
  belongs_to :company
  belongs_to :user

  has_many :journal_entry_transactions
  has_many :item_lists

  validates :account_no, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :statement_ending_balance, numericality: {greater_than_or_equal_to: 0}, if: :ending_balance_exist?

  delegate :name, :id, to: :chart_account_type, prefix: true, allow_nil: true

  scope :find_data, ->{includes(:chart_account_type).order("chart_account_types.name ASC")}
  scope :find_account_receivables, ->{includes(:chart_account_type)
    .where("chart_account_types.type_code = ?", Settings.account_type.ar)
    .order(name: :ASC)
    .references("chart_account_types")}

  def chart_account_name
    "#{account_no}-#{name}"
  end

  def balance_total
    total_debit = journal_entry_transactions.sum :debit
    total_credit = journal_entry_transactions.sum :credit
    balance = chart_account_type.debit? ? (total_debit - total_credit) : (total_credit - total_debit)
    balance += statement_ending_balance
  end

  def data_used?
    journal_entry_transactions.present? || item_lists.present?
  end

  def update_active
    update_attributes active: 1
  end

  def update_inactive
    update_attributes active: 0
  end

  def account_receivable?
    chart_account_type.type_code == Settings.account_type.ar
  end

  def account_payable?
    chart_account_type.type_code == Settings.account_type.ap
  end

  def selectize_data
    if account_receivable? || account_payable?
      ChartAccountType.where id: chart_account_type_id
    else
      ChartAccountType.not_ar_ap
    end
  end

  private
  def ending_balance_exist?
    statement_ending_balance.present?
  end
end
