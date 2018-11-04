module Cssz
  module Requests
    class ZobrazZamestnavatele

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
        :zobraz_zamestnavatele
      end

      def request_body
        {'PozadavekData' => inner_body}
      end

      def person_data(index=self.person_index)
        data.insured_people[index]
      end

      def inner_body
        {
          'Pojistenec' => insured_person_details(person_data),
          'Obdobi' => interval,
          'PouzeOtevreneVztahy' => data.actual_employments_only || true,
          'DuvodOpravnenostiDotazu' => data.request_legitimacy_reason,
        }
      end

    end
  end
end
