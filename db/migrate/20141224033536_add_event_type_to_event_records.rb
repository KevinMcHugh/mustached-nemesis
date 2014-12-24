class AddEventTypeToEventRecords < ActiveRecord::Migration
  def change
    add_column :event_records, :eventtype, :string
  end
end
