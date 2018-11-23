class AddIntervalToInformationRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :information_requests, :interval_from, :date
    add_column :information_requests, :interval_to, :date
  end
end
