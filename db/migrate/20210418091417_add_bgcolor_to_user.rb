class AddBgcolorToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :bgcolor, :string, default: '#005a55'
  end
end
