class CreateRentals < ActiveRecord::Migration[5.1]
  def change
    create_table :rentals do |t|
      t.string :name
      t.integer :daily_rate

      t.timestamps
    end
  end
end
