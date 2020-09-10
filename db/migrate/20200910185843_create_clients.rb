class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients, id: :uuid do |t|
      t.string :secret_digest

      t.timestamps
    end
  end
end
