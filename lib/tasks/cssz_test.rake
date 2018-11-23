namespace :cssz_test do

  def person_attributes1
    {
      firstname: 'Otto',
      lastname: 'Karlický',
      birth_date: '1961/2/20',
      birth_number: '6102201160'
    }
  end
  def person_attributes2
    {
      firstname: 'Vilemína',
      lastname: 'Bičovská',
      birth_date: '1960/3/24',
      birth_number: '6053241359'
    }
  end

  desc "Test pracovnich neschopnosti"
  task :prac_neschopnost => :environment do
    ir = InformationRequest.new(
      insured_person_type: 'individual',
      insured_people_attributes: { '1' => person_attributes2 },
      request_legitimacy_reason: 'XX-XXX-XXXX/XXXX'
    )
    req = Cssz::Requests::SeznamPracovnichNeschopnosti.new(ir)
    soap = req.send
    pp soap.body
  end
end
