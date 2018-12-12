module Cssz
  module Requests
    class NemocenskeDavky < ::Cssz::Request

      attr_accessor :person_index

      def initialize(*attrs)
        super
        @person_index = 0
      end

      def service_path
        '/IkreZobrazVysiDruhDuchoduHromadne-v1'
      end

      def service_code
        'IkreZobrazVysiDruhDuchoduHromadne'
      end

      def service_namespace
        'urn:cz:isvs:cssz:schemas:IkreZobrazVysiDruhDuchoduHromadne:v1'
      end

      def soap_method
        :ikre_zobraz_vysi_druh_duchodu_hromadne
      end

      def request_body
        {"#{request_ns}:PozadavekData" => inner_body}
      end

      def person_data(index=self.person_index)
        data.insured_people[index]
      end

      def inner_body
        {
          # can be repeated up to 100 times
          "#{request_ns}:ZaznamVstup" => {
            "#{request_ns}:Pojistenec" => insured_person_details(person_data),
            "#{request_ns}:Obdobi" => interval,
            "#{request_ns}:DuvodOpravnenostiDotazu" => data.request_legitimacy_reason,
            # If to include the address of the payment
            "#{request_ns}:Priznak" => convert_boolean(data.include_addresses, true),
          }
        }
      end

      def send
        super unless Cssz::Settings.stub_test_data?
      end

      def parse_response(soap_response)
        if !Cssz::Settings.stub_test_data?
          data = soap_response.body[:ikre_zobraz_vysi_druh_duchodu_hromadne_odpoved]
          data = Array.wrap(data[:odpoved_data][:zaznam_vystup]).first
          pensions = Array.wrap(data[:duchod])
          pensions_data = pensions.collect do |pension|
            {
              'pension_type' => pension[:druh_duchodu],
              'start' => pension[:platba_od],
              'end'   => pension[:platba_do],
              'payment_type_name'   => pension[:nazev_zpusobu_vyplaty],
              'paid_amount' => pension[:vyse_duchodu_netto],
              'pension_amount' => pension[:vyse_duchodu],
              'paid_on' => pension[:datum_vyplaty]
              # missing maping of Srazka, codes of payment, AdresaDuchodu, PrijemceDuchodu, UcetDuchodu
            }
          end

          {
            'records_found' => 'OK' == data[:aplikacni_status][:vysledek_kod],
            'pensions' =>  pensions_data
          }
        else
          stubed_test_data
        end
      end

      def stubed_test_data
        {
          'records_found' => true,
          'pensions' => [
            {
              'pension_type' => 'Typ duchodu',
              'start' => Date.new(2018, 10, 1),
              'end'   => Date.new(2018, 10, 31),
              'payment_type_name'   => 'Nezname hodnoty',
              'paid_amount' => 5000,
              'pension_amount' => 6000,
              'paid_on' => Date.new(2018, 11, 6)
              # missing maping of Srazka, codes of payment, AdresaDuchodu, PrijemceDuchodu, UcetDuchodu
            }
          ]
        }
      end

    end
  end
end
