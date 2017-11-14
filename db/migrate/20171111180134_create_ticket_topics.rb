class CreateTicketTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :ticket_topics do |t|
      t.references :ticket, foreign_key: true
      t.references :user, foreign_key: true
      t.text :description, null: false
      t.datetime :created_at
    end
  end
end
