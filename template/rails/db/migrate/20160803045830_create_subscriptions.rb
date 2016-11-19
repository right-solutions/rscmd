class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :email, :null => false, limit: 256
      t.timestamps null: false
    end
  end
end
