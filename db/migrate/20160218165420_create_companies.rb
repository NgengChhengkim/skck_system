class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|

      t.string :name
      t.string :short_name
      t.string :address
      t.string :contact
      t.timestamps null: false
    end
  end
end
