class CreateItemLists < ActiveRecord::Migration
  def change
    create_table :item_lists do |t|
      t.string :name
      t.string :description
      t.string :manufacturer_part_number
      t.float :cost
      t.float :price
      t.string :purchase_description
      t.string :sale_description
      t.boolean :active, default: 1
      t.references :chart_of_account, index: true, foreign_key: true
      t.references :income_account, references: :chart_of_account
      t.references :cogs_account, references: :chart_of_account
      t.references :company, index: true, foreign_key: true
      t.references :customer_vender, index: true, foreign_key: true
      t.references :item_list_type, index: true, foreign_key: true
      t.references :unit_of_measure, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
