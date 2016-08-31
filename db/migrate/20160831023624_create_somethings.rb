class CreateSomethings < ActiveRecord::Migration[5.0]
  def change
    create_table :somethings do |t|
      t.string :instanceid
      t.string :todo_action

      t.timestamps
    end
  end
end
