class CreateKmeans < ActiveRecord::Migration
  def change
    create_table :kmeans do |t|
      t.integer :cluster_id
      t.string :link
      t.integer :search_id
      t.integer :web
      t.integer :url_id
      t.integer :count
      t.timestamps null: false
    end
  end
end
