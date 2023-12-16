class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.references :city, null: false, foreign_key: true
      t.integer :humidity

      t.timestamps
    end
  end
end
