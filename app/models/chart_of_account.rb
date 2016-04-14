class ChartOfAccount < ActiveRecord::Base
  has_closure_tree

  belongs_to :chart_account_type
  belongs_to :company
  belongs_to :user

  has_many :journal_entry_transactions
  has_many :item_lists

  validates :account_no, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 255}
  validates :statement_ending_balance, numericality: {greater_than_or_equal_to: 0}, if: :ending_balance_exist?
  validate :name_existed

  delegate :name, :id, to: :chart_account_type, prefix: true, allow_nil: true

  enum status: [:inactive, :active]

  scope :find_data, ->{includes(:chart_account_type).order("chart_account_types.name ASC")}

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

  def active
    update_attributes status: :active
  end

  def inactive
    update_attributes status: :inactive
  end

  def account_receivable?
    chart_account_type.type_code == Settings.account_type.ar
  end

  def account_payable?
    chart_account_type.type_code == Settings.account_type.ap
  end
  private
  def ending_balance_exist?
    statement_ending_balance.present?
  end

  def name_existed
    if parent_id.present?
      children_name = ChartOfAccount.find(parent_id).children.where.not(id: id).map(&:name)
    else
      children_name = ChartOfAccount.roots.where.not(id: id).map(&:name)
    end
    errors.add :name, I18n.t("chart_of_accounts.messages.existed") if
      children_name.map(&:downcase).include? name.downcase
  end
end
