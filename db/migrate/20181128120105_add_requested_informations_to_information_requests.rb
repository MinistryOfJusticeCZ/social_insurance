class AddRequestedInformationsToInformationRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :information_requests, :requested_informations, :string
  end
end
