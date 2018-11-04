class CreateInformationRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :information_requests do |t|
      t.string :file_uid
      t.string :court_uid

      t.integer :insured_person_type

      t.timestamps
    end
  end
end
