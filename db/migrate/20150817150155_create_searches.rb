class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
    	t.string :query
    	t.integer :link_num
      t.timestamps null: false
    end
  end
end
