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

      def convert_boolean(value, default=nil)
        value = default if value.nil?
        value ? 'A' : 'N'
      end

      def inner_body
        {
          "#{request_ns}:Pojistenec" => insured_person_details(person_data),
          "#{request_ns}:Obdobi" => interval,
          "#{request_ns}:PouzeOtevreneVztahy" => convert_boolean(data.actual_employments_only, true),
          "#{request_ns}:DuvodOpravnenostiDotazu" => data.request_legitimacy_reason,
        }
      end

    end
  end
end
