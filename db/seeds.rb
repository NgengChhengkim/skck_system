Company.create! name: "Framgia"
Company.create! name: "Microsoft"
Company.create! name: "Apple"
Company.create! name: "Samsung"

company = Company.first
company.users.create! name: "john", email: "admin@gmail.com", password: "12345678",
  password_confirmation: "12345678", role: 0

ChartAccountType.create! name: "Bank", type_code: "bank", increament_at: 0
ChartAccountType.create! name: "Accounts Receivable", type_code: "ar", increament_at: 0
ChartAccountType.create! name: "Other Cursrent Asset", type_code: "oca", increament_at: 0
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

ChartAccountType.all.each_with_index do |type, no|
  company.chart_of_accounts.create! account_no: "#{no}",
    name: "Chart Of Account #{no}", chart_account_type: type, active: 1
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

company.customer_venders.create! name: "customer", email: "customer@gmail.com", status: 0
company.customer_venders.create! name: "vender", email: "vender@gmail.com", status: 1

WorkingPeriod.create! start_date: "2016-04-01", end_date: "2016-04-30", company_id: 1

# item list type
item_list_types = ["Service", "Inventory Part", "Non-inventory Part", "Other Charge",
                    "Discount"]
item_list_types.each do |type|
  ItemListType.create! name: type
end
# measure and unit of measure
measures = ["Count", "Length", "Weight", "Volume", "Area", "Time"]
unit_of_measures = [["each", "box", "case", "dozen"],
                    ["inch", "foot", "yart", "meter"]  ,
                    ["ounce", "pound", "kilogram"],
                    ["guart", "gallon", "cubic yard", "liter"],
                    ["square foot", "arce", "square", "meter"],
                    ["minute", "hour", "day"]]
count = 0
measures.each do |measure|
  m = Measure.create! name: measure, company: company
  unit_of_measures[count].each do |unit|
    m.unit_of_measures.create! name: unit, abbreviation: unit, company_id: company.id
  end
  count = count + 1
end

# item list
ItemListType.all.each do |type|
  (1..3).each do |n|
    type.item_lists.create! name: type.name + "#{n}", manufacturer_part_number: type.id,
    company: company, unit_of_measure: UnitOfMeasure.all.sample,
    customer_vender: CustomerVender.all.sample, chart_of_account: ChartOfAccount.all.sample
  end
end
