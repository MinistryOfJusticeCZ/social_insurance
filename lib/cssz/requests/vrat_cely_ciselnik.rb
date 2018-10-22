module Cssz
  module Requests
    class VratCelyCiselnik < Request

      def service_path
        '/IkreVratCelyCiselnik-v1'
      end

      def service_code
        'IkreVratCelyCiselnik'
      end

      def service_namespace
        'urn:cz:isvs:cssz:schemas:IkreVratCiselnik:v1'
      end

      def soap_method
        :vrat_cely_ciselnik
      end

      def request_body
        {'PozadavekData' => {'UrceniCiselniku' => {'ikreTypes:NazevCiselniku' => 'DruhCinnostiZam'}}}
      end

    end
  end
end
