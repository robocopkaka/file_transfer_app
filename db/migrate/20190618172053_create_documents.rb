# frozen_string_literal: true

# Document migration
class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :name, null: false, default: ''

      t.timestamps
    end
  end
end
