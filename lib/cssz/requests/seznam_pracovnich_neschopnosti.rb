module Cssz
  module Requests
    class SeznamPracovnichNeschopnosti < ::Cssz::Request

      attr_accessor :person_index

      def initialize(*attrs)
        super
        @person_index = 0
      end

      def service_path
        '/IkreZobrazSeznamPNPojistence-v1'
      end

      def service_code
        'IkreZobrazSeznamPNPojistence'
      end

      def service_namespace
        'urn:cz:isvs:cssz:schemas:IkreZobrazSeznamPNPojistence:v1'
      end

      def soap_method
        :ikre_zobraz_seznam_pn_pojistence
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
        }
      end

      def parse_response(soap_response)
        data = soap_response.body[:ikre_zobraz_seznam_pn_pojistence_odpoved]
        incapacities = Array.wrap(data[:odpoved_data][:pracovni_neschopnost])
        incapacities_data =
          if !Cssz::Settings.stub_test_data?
            incapacities.collect do |neschopnost|
              {
                'decision_number' => neschopnost[:cislo_rozhodnuti],
                'start' => neschopnost[:zacatek_pracovni_neschopnosti],
                'end'   => neschopnost[:konec_pracovni_neschopnosti],
                'length' => neschopnost[:delka_pripadu]
              }
            end
          else
            incapacities_data = [
              {
                'decision_number' => '152645',
                'start' => Date.new(4, 11, 2018),
                'end' => Date.new(19, 11, 2018),
                'length' => 15
              }
            ]
          end

        {
          'records_not_found' => 'VAROVANI' == data[:aplikacni_status][:vysledek_kod],
          'incapacities' =>  incapacities_data
        }
      end

    end
  end
end
