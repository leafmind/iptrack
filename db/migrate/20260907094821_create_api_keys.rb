class CreateApiKeys < ActiveRecord::Migration[8.1]
  def change
    create_table :api_keys do |t|
      t.string :token, null: false
      t.integer :role, default: 0, null: false
      t.timestamps
    end

    add_index :api_keys, :token, unique: true
  end
end
