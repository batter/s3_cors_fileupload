class CreateSourceFiles < ActiveRecord::Migration
  def change
    create_table :source_files do |t|
      t.string :file_name
      t.string :file_content_type
      t.integer :file_size
      t.string :url
      t.string :_key
      t.string :_bucket

      t.timestamps
    end
  end
end
