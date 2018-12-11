module Cssz
  module Requests
    class NemocenskeDavky < ::Cssz::Request

      attr_accessor :person_index

      def initialize(*attrs)
        super
        @person_index = 0
      end

      def service_path
        '/IkreZobrazDruhVyseNDPojistence-v1'
      end

      def service_code
        'IkreZobrazDruhVyseNDPojistence'
      end

      def service_namespace
        'urn:cz:isvs:cssz:schemas:IkreZobrazDruhVyseNDPojistence:v1'
      end

      def soap_method
        :ikre_zobraz_druh_vyse_nd_pojistence
      end

      def request_body
        {"#{request_ns}:PozadavekData" => inner_body}
      end

      def person_data(index=self.person_index)
        data.insured_people[index]
      end

      def inner_body
        {
          "#{request_ns}:Pojistenec" => insured_person_details(person_data),
          "#{request_ns}:Obdobi" => interval,
          "#{request_ns}:DuvodOpravnenostiDotazu" => data.request_legitimacy_reason,
          "#{request_ns}:ZpusobVyplaty" => convert_boolean(data.actual_employments_only, true),
        }
      end

      def send
        super unless Cssz::Settings.stub_test_data?
      end

      def parse_response(soap_response)
        if !Cssz::Settings.stub_test_data?
          data = soap_response.body[:ikre_zobraz_druh_vyse_nd_pojistence_odpoved]
          benefits = Array.wrap(data[:odpoved_data][:nemocenska_davka])
          benefits_data = benefits.collect do |benefit|
            {
              'benefit_type_name' => benefit[:nazev_druhu_davky],
              'benefit_state' => benefit[:stav_davky_ikr],
              'start' => benefit[:zacatek_obdobi],
              'end'   => benefit[:konec_obdobi],
              'paid_amount' => benefit[:vyplaceno],
              'benefit_amount' => benefit[:vyse_davky],
              'paid_on' => benefit[:odeslana_dne]
              # missing maping of VyseSrazky, DavkaVyplacenaNa, VyplacejiciOSSZ
            }
          end

          {
            'records_found' => 'OK' == data[:aplikacni_status][:vysledek_kod],
            'sickness_benefits' =>  benefits_data
          }
        else
          stubed_test_data
        end
      end

      def stubed_test_data
        {
          'records_found' => true,
          'sickness_benefits' => [
            {
              'benefit_type_name' => "Test - nezname hodnoty",
              'benefit_state' => "test / nezname hodnoty",
              'start' => Date.new(2018, 10, 4),
              'end'   => Date.new(2018, 10, 9),
              'paid_amount' => 1500,
              'benefit_amount' => 2000,
              'paid_on' => Date.new(2018, 10, 12)
              # missing maping of VyseSrazky, DavkaVyplacenaNa, VyplacejiciOSSZ
            },
            {
              'benefit_type_name' => "Test - nezname hodnoty",
              'benefit_state' => "test / nezname hodnoty",
              'start' => Date.new(2018, 7, 4),
              'end'   => Date.new(2018, 7, 9),
              'paid_amount' => 1500,
              'benefit_amount' => 1500,
              'paid_on' => Date.new(2018, 7, 12)
              # missing maping of VyseSrazky, DavkaVyplacenaNa, VyplacejiciOSSZ
            }
          ]
        }
      end

    end
  end
end
