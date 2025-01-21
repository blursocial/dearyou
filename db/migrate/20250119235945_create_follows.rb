class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.string :status, default: "pending" # status can be 'pending', 'accepted', 'rejected'
      t.timestamps
    end
  end
end
