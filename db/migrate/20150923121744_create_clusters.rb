class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.string :url_id
      t.string :count

      t.timestamps null: false
    end
  end
end
