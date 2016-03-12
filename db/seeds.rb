Company.create! name: "Framgia"
Company.create! name: "Microsoft"
Company.create! name: "Apple"
Company.create! name: "Samsung"

company = Company.first
company.users.create! name: "john", email: "admin@gmail.com", password: "12345678",
  password_confirmation: "12345678", role: 0

ChartAccountType.create! name: "Bank", type_code: "bank", increament_at: 0
ChartAccountType.create! name: "Accounts Receivable", type_code: "ar", increament_at: 0
ChartAccountType.create! name: "Other Curent Asset", type_code: "oca", increament_at: 0
ChartAccountType.create! name: "Fixed Asset", type_code: "fa", increament_at: 0
ChartAccountType.create! name: "Other Asset", type_code: "of", increament_at: 0
ChartAccountType.create! name: "Accounts Payable", type_code: "ap", increament_at: 1
ChartAccountType.create! name: "Other Current Liability", type_code: "ocl", increament_at: 1
ChartAccountType.create! name: "Long Term Liability", type_code: "ltl", increament_at: 1
ChartAccountType.create! name: "Equity", type_code: "equity", increament_at: 1
ChartAccountType.create! name: "Income", type_code: "income", increament_at: 1
ChartAccountType.create! name: "Cost of Goods Sold", type_code: "cgs", increament_at: 0
ChartAccountType.create! name: "Expense", type_code: "expense", increament_at: 0
ChartAccountType.create! name: "Other Income", type_code: "oi", increament_at: 1
ChartAccountType.create! name: "Other Expense", type_code: "oe", increament_at: 0

30.times do |n|
  company.chart_of_accounts.create! account_no: n,
    name: "Chart Of Account #{n}", chart_account_type: ChartAccountType.all.sample,
    parent_id: ChartOfAccount.all.sample.try(:id)
end

# company.chart_of_accounts.create! account_no: "1234", name: "ANZ Royal Bank", chart_account_type_id: 1
# company.chart_of_accounts.create! account_no: "5678", name: "Account Receivable", chart_account_type_id: 2
# company.chart_of_accounts.create! account_no: "9231", name: "Account Payable", chart_account_type_id: 3
# company.chart_of_accounts.create! account_no: "9283", name: "Cash on hand", chart_account_type_id: 4

VoucherType.create! name: "Cash In Voucher", abbreviation: "CIV"
VoucherType.create! name: "Cash Out Voucher", abbreviation: "COV"

CashType.create! name: "Safe"
CashType.create! name: "Bank"

BankType.create! name: "ACLEDA Bank", cash_type_id: 2, company_id: 1
BankType.create! name: "Sacombank Bank", cash_type_id: 2, company_id: 1
BankType.create! name: "Safe on Hand", cash_type_id: 1, company_id: 1
BankType.create! name: "Petty cash", cash_type_id: 1, company_id: 1

company.customer_venders.create! name: "customer", status: "Customer"
company.customer_venders.create! name: "vender", status: "Vender"

WorkingPeriod.create! start_date: "2016-03-01", end_date: "2016-03-30", company_id: 1
