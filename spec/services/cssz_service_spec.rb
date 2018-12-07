require 'rails_helper'

RSpec.describe CsszService do

  def stub_getting_wsdl_definitions
    stub_request(:get, "https://cssz.example.com/B2B/IkreZobrazZamestnavatele-v1?wsdl").
      to_return(
        status: 200,
        body: Rails.root.join("spec/support/data/ikre/wsdl/IkreZobrazZamestnavatele-v1.wsdl").read
      )
    stub_request(:get, "https://cssz.example.com/B2B/IkreZobrazSeznamPNPojistence-v1?wsdl").
      to_return(
        status: 200,
        body: Rails.root.join("spec/support/data/ikre/wsdl/IkreZobrazSeznamPNPojistence-v1.wsdl").read
      )
  end

  def stub_seznam_zamestnavatelu
    stub_request(:post, "https://cssz.example.com/B2B/IkreZobrazZamestnavatele-v1").
    #   with(body: <<-XML.split("\n").map(&:strip).join
    #       <?xml version="1.0" encoding="UTF-8"?>
    #       <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    #                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    #                     xmlns:req="urn:cz:isvs:cssz:schemas:IkreZobrazZamestnavatele:v1"
    #                     xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
    #                     xmlns:ikre="urn:cz:isvs:cssz:schemas:IkreMessages:v1"
    #                     xmlns:ikreTypes="urn:cz:isvs:cssz:schemas:IkrMessageTypes:v1">
    #       <env:Body>
    #         <req:IkreZobrazZamestnavatele>
    #           <ikre:PozadavekHlavicka>
    #             <ikre:KodSluzby>IkreZobrazZamestnavatele</ikre:KodSluzby>
    #             <ikre:PozadavekInfo>
    #               <ikreTypes:Cas>2018-12-04T02:14:39+01:00</ikreTypes:Cas>
    #               <ikreTypes:DuvodUcel>Test</ikreTypes:DuvodUcel>
    #               <ikreTypes:Popis>Test2</ikreTypes:Popis>
    #               <ikreTypes:VstupniKanalId>B2B</ikreTypes:VstupniKanalId>
    #               <ikreTypes:PozadovanyVystupniKanalId>B2B</ikreTypes:PozadovanyVystupniKanalId>
    #             </ikre:PozadavekInfo>
    #             <ikre:KlientInfo>
    #               <ikreTypes:TypKlienta>OVM</ikreTypes:TypKlienta>
    #               <ikreTypes:KlientId>MSP</ikreTypes:KlientId>
    #               <ikreTypes:OrganizaceInfo>
    #                 <ikreTypes:NazevOrganizace>Ministerstvo spravedlnosti</ikreTypes:NazevOrganizace>
    #                 <ikreTypes:ICO>021546554</ikreTypes:ICO>
    #               </ikreTypes:OrganizaceInfo>
    #               <ikreTypes:IdentifikatorDatoveSchranky>klsdaf</ikreTypes:IdentifikatorDatoveSchranky>
    #             </ikre:KlientInfo>
    #           </ikre:PozadavekHlavicka>
    #           <req:PozadavekData>
    #             <req:Pojistenec>
    #               <ikreTypes:Jmeno>Pavla</ikreTypes:Jmeno>
    #               <ikreTypes:Prijmeni>Hars</ikreTypes:Prijmeni>
    #               <ikreTypes:DatumNarozeni>1961-02-16</ikreTypes:DatumNarozeni>
    #               <ikreTypes:RodneCislo>6102201160</ikreTypes:RodneCislo>
    #               <ikreTypes:PrijmeniRodne>Novak</ikreTypes:PrijmeniRodne>
    #             </req:Pojistenec>
    #             <req:Obdobi>
    #               <ikreTypes:KeDni>2018-12-04</ikreTypes:KeDni>
    #             </req:Obdobi>
    #             <req:PouzeOtevreneVztahy>A</req:PouzeOtevreneVztahy>
    #             <req:DuvodOpravnenostiDotazu>Testtest test test.</req:DuvodOpravnenostiDotazu>
    #           </req:PozadavekData>
    #         </req:IkreZobrazZamestnavatele>
    #       </env:Body>
    #     </env:Envelope>
    #   XML
    # ).
      to_return(status: 200, body: Rails.root.join("spec/support/data/responses/zamestnavatele_1.xml"))
  end

  def stub_incapacities
    stub_request(:post, "https://cssz.example.com/B2B/IkreZobrazSeznamPNPojistence-v1").
      to_return(status: 200, body: Rails.root.join("spec/support/data/responses/neschopnosti_1.xml"))
  end

  def request_attributes(req_info=%w(employments incapacities))
    {
      insured_people: [insured_person],
      requested_informations: req_info,
      interval_from: Date.today - 1.year,
      interval_to: nil,
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
      stub_getting_wsdl_definitions
      stub_seznam_zamestnavatelu
      stub_incapacities
    end

    let(:insured_person) { instance_double('InsuredPerson', firstname: 'Pavla', lastname: 'Hars', birth_date: Date.new(1961, 2, 16), birth_number: '6102201160', birth_lastname: 'Novak') }
    let(:information_request){ instance_double('InformationRequest', request_attributes) }
    subject{ CsszService.new(information_request) }

    it 'calls cssz services' do
      data = subject.get_cssz_data.first
      expect(data).to have_key('person')
      expect(data).to have_key('incapacities')
      expect(data['incapacities'].first).to have_key('decision_number')
    end

  end

end
