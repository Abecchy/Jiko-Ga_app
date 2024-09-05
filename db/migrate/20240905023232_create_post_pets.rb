class CreatePostPets < ActiveRecord::Migration[7.0]
  def change
    create_table :post_pets do |t|
      t.references :post, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end

    add_index :post_pets, [:post_id, :pet_id], unique: true
  end
end
