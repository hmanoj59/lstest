class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.string :instanceid
      t.string :todo

      t.timestamps
    end
  end
end
