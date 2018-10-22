module Cssz
  module Requests
    class ZobrazZamestnavatele

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

      def inner_body
        {
          'Pojistenec' => insured_person_details,
          'Obdobi' => interval,
          'PouzeOtevreneVztahy' => data.actual_employments_only || true,
          'DuvodOpravnenostiDotazu' => data.request_legitimacy_reason,
        }
      end

    end
  end
end
