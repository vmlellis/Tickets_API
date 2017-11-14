class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :ticket_type, foreign_key: true
      t.text :title, null: false
      t.text :description, null: false
      t.integer :status, default: 0, null: false
      t.integer :created_by_id,
                null: false, foreign_key: { to_table: :user }, index: true
      t.integer :closed_by_id, foreign_key: { to_table: :user }, index: true
      t.datetime :closed_at
      t.integer :agent_id, foreign_key: { to_table: :user }, index: true

      t.timestamps null: false
    end
  end
end
