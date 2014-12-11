class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :deleted_at
      t.string :title
      t.string :uuid, unique: true

      t.timestamps
    end
  end
end
