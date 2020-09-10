class CreateShortenedUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :shortened_urls do |t|
      t.string :sequence, null: false

      t.timestamps
    end
  end
end
