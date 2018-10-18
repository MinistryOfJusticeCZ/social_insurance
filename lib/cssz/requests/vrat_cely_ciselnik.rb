module Cssz
  module Requests
    class VratCelyCiselnik < Request

      def request_body
        {'PozadavekData' => {'UrceniCiselniku' => {'ikreTypes:NazevCiselniku' => 'DruhCinnostiZam'}}}
      end

    end
  end
end
