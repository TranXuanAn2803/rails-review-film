class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :description
      t.belongs_to :film, foreign_key: true

      t.timestamps
    end
  end
end
