class CreateCaves < ActiveRecord::Migration[5.0]
  def change
    create_table :caves do |t|
      t.string :title
      t.string :description
      
      t.timestamps
    end
  end
end
