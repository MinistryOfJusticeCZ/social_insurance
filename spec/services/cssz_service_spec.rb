require 'rails_helper'

RSpec.describe CsszService do

  def stub_getting_wsdl_definition
    stub_request(:get, "https://i.example.org/Services/WebshopIntegration.asmx?WSDL").
      to_return(
        status: 200,
        body: Rails.root.join("spec/support/data/ikre/wsdl/IkreZobrazSeznamPNPojistence-v1.wsdl").read,
      )
  end

  def request_attributes
    {
      insured_people: [insured_person],
      reason: 'Test',
      reason_description: 'Test2',
      actual_employments_only: true,
      request_legitimacy_reason: 'Testtest test test.'
    }
  end

  describe '#get_cssz_data' do

    before(:each) do
      set_dbl = double(Cssz::Settings,
        cssz_server: 'cssz.example.com',
        client_certificate_file: nil,
        client_key_file: nil,
        client_key_password: nil,
        client_id: 'MSP',
        organization_name: 'Ministerstvo spravedlnosti',
        organization_ico: '021546554',
        organization_ds_id: 'klsdaf'
      )
      stub_const('Cssz::Settings', set_dbl)
    end

    let(:insured_person) { instance_double('InsuredPerson', firstname: 'Pavla', lastname: 'Hars', birth_date: Date.new(1961, 2, 16), birth_number: '6102201160', birth_lastname: 'Novak') }
    let(:information_request){ instance_double('InformationRequest', request_attributes) }
    subject{ CsszService.new(information_request) }

    it 'calls cssz services' do
      subject.get_cssz_data
    end

  end

end