class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.string :identity
      t.references :ticket_type, foreign_key: true
      t.string :title
      t.string :description
      t.integer :status, default: 0, null: false
      t.integer :created_by_id, foreign_key: { to_table: :user }, index: true
      t.datetime :created_at
      t.integer :closed_by_id, foreign_key: { to_table: :user }, index: true
      t.datetime :closed_at
      t.integer :agent_id, index: true
    end
  end
end
