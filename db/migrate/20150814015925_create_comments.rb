class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :micropost, index: true
      t.text :comment

      t.timestamps
    end
  end
end
