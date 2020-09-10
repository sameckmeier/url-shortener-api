class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.string :original, null: false
      t.string :shortened, unique: true, null: false

      t.references :client, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end
  end
end
