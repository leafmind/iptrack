class CreateGeocodes < ActiveRecord::Migration[8.1]
  def change
    create_table :geocodes do |t|
      t.string :target, null: false
      t.boolean :host, default: false, null: false
      t.float :latitude
      t.float :longitude
      t.string :country
      t.string :city
      t.json :payload

      t.timestamps
    end

    add_index :geocodes, [:target, :host], unique: true
  end
end
