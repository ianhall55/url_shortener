class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :url_id

      t.timestamps null: false
    end

    add_index :visits, :user_id
    add_index :visits, :url_id
    add_index :visits, [:user_id, :url_id]
  end


end
