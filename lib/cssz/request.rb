module Cssz
  class Request

    # ---- To override ----
    def service_path
      '/IkreVratCelyCiselnik-v1'
    end

    def service_code
      'IkreVratCelyCiselnik'
    end

    def service_namespace
      'urn:cz:isvs:cssz:schemas:IkreVratCiselnik:v1'
    end

    def request_body
      {}
    end

    def soap_method
      :dummy
    end

    def parse_response(soap_response)

    end
    # ---- end override ----

    attr_reader :data, :reason, :reason_description

    def initialize(request_data)
      @data = request_data
      @reason, @reason_description = request_data.reason, request_data.reason_description
    end

    def service
      @service ||= Service.new
    end

    def send
      @soap_response = service.send_request(self)
    end

    def response
      @response ||= parse_response(@soap_response)
    end

    def types_ns
      Cssz::Service::TYPES_NS_ID
    end

    def request_ns
      Cssz::Service::REQUEST_NS_ID
    end

    protected

      # Converts boolean to the soap Asseco representation
      def convert_boolean(value, default=nil)
        value = default if value.nil?
        case value
        when true
          'A'
        when false
          'N'
        end
      end

      # Returns definition of interval from an inputed date.
      # If there was no date on input, it takes today as a date.
      #
      # Interface of cssz allows interval as from to dates, but it is not needed by courts
      def interval
        from = data.interval_from || Date.new(Date.today.year - 1, 1, 1)
        res = {"#{types_ns}:ZacatekIntervalu" =>  from.to_date.iso8601}
        res.merge!("#{types_ns}:KonecIntervalu" =>  data.interval_to.to_date.iso8601) if data.interval_to
        res
      end

      # Returns a identification of the insured person from the inputed data.
      def insured_person_details(person_data)
        {
          "#{types_ns}:Jmeno" => person_data.firstname,
          "#{types_ns}:Prijmeni" => person_data.lastname,
          "#{types_ns}:DatumNarozeni" => person_data.birth_date,
          "#{types_ns}:RodneCislo" => person_data.birth_number
        }.merge( person_data.birth_lastname.blank? ? {} : {"#{types_ns}:PrijmeniRodne" => person_data.birth_lastname})
      end

  end
end
