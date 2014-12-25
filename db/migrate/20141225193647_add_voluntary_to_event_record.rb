class AddVoluntaryToEventRecord < ActiveRecord::Migration
  def change
    add_column :event_records, :voluntary, :boolean
  end
end
