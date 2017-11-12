class CreateTicketTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :ticket_answers do |t|
      t.references :ticket, foreign_key: true
      t.references :user, foreign_key: true
      t.datetime :created_at
    end
  end
end
