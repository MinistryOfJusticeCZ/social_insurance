module Cssz
  module Requests
    class ZobrazZamestnavatele < ::Cssz::Request

      attr_accessor :person_index

      def service_path
        '/IkreZobrazZamestnavatele-v1'
      end

      def service_code
        'IkreZobrazZamestnavatele'
      end

      def service_namespace
        'urn:cz:isvs:cssz:schemas:IkreZobrazZamestnavatele:v1'
      end

      def soap_method
        :ikre_zobraz_zamestnavatele
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
          "#{request_ns}:PouzeOtevreneVztahy" => convert_boolean(data.actual_employments_only, true),
          "#{request_ns}:DuvodOpravnenostiDotazu" => data.request_legitimacy_reason,
        }
      end

      def parse_response(soap_response)
        data = soap_response[:ikre_zobraz_zamestnavatele_odpoved][:odpoved_data]
        {
          'employments' => Array.wrap(data[:zamestnani_zamestnavatelem]).collect do |ed|
            {
              'employer_name' => ed[:uctarna_zamestnavatele][:nazev],
              'start' => ed[:zamestnani][:zacatek_vztahu]
            }
          end
        }
      end

    end
  end
end
