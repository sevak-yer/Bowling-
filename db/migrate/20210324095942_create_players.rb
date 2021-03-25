class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :cell1
      t.integer :cell2
      t.integer :cell3
      t.integer :count
      t.boolean :spare
      t.integer :score
      t.integer :throw
      t.boolean :strike1
      t.integer :st1_score
      t.integer :st1_count
      t.boolean :strike2
      t.integer :st2_score
      t.integer :st2_count
      t.integer :st3_score
      t.boolean :gameover
      t.text :notice
      t.integer :remaining

      t.timestamps
    end
  end
end
