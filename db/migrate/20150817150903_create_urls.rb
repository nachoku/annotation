class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
    	t.integer :search_id
    	t.string :link
    	t.text :web
      t.timestamps null: false
    end
  end
end
