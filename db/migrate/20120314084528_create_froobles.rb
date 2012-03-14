class CreateFroobles < ActiveRecord::Migration
  def change
    create_table :froobles do |t|
      t.string :name
      t.string :color
      t.text :description

      t.timestamps
    end
  end
end
