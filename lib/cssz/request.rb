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
      @response = service.send_request(self)
    end

    def response
      @response
    end

    def types_ns
      Cssz::Service::TYPES_NS_ID
    end

    def request_ns
      Cssz::Service::REQUEST_NS_ID
    end

    protected

      # Returns definition of interval from an inputed date.
      # If there was no date on input, it takes today as a date.
      #
      # Interface of cssz allows interval as from to dates, but it is not needed by courts
      def interval
        {"#{types_ns}:KeDni" =>  (data.on_day || Date.today).to_date.iso8601}
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
