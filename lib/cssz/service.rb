module Cssz
  class Service

    MESSAGES_NS_ID = 'ikre'
    TYPES_NS_ID = 'ikreTypes'

    def base_url
      "https://#{Cssz::Settings.cssz_server}/B2B"
    end

    def base_namespaces
      {"xmlns:#{MESSAGES_NS_ID}"=>"urn:cz:isvs:cssz:schemas:IkreMessages:v1", "xmlns:#{TYPES_NS_ID}"=>"urn:cz:isvs:cssz:schemas:IkrMessageTypes:v1"}
    end

    def client(request)
      Savon.client(
          wsdl: base_url + request.service_path + '?wsdl',
          endpoint: base_url + request.service_path,
          namespace: request.service_namespace,
          ssl_cert_file: Cssz::Settings.client_certificate_file,
          ssl_cert_key_file: Cssz::Settings.client_key_file,
          ssl_cert_key_password: Cssz::Settings.client_key_password,
          ssl_verify_mode: :none,
          convert_request_keys_to: :camelcase
          #, log: true, log_level: :debug, pretty_print_xml: true
        ) { namespaces base_namespaces }
    end

    def request_payload(request)
      {"#{MESSAGES_NS_ID}:PozadavekHlavicka" => request_head(request)}.merge(request.request_body)
    end

    def request_head(request)
      {
        "#{MESSAGES_NS_ID}:KodSluzby" => request.service_code,
        "#{MESSAGES_NS_ID}:PozadavekInfo" => {
          "#{TYPES_NS_ID}:Cas" => Time.now.iso8601,
          "#{TYPES_NS_ID}:DuvodUcel" => request.reason,
          "#{TYPES_NS_ID}:Popis" => request.reason_description,
          "#{TYPES_NS_ID}:VstupniKanalId" => 'B2B',
          "#{TYPES_NS_ID}:PozadovanyVystupniKanalId" => 'B2B'
        },
        "#{MESSAGES_NS_ID}:KlientInfo" => {
          "#{TYPES_NS_ID}:TypKlienta" => 'OVM',
          "#{TYPES_NS_ID}:KlientId" => Cssz::Settings.client_id,
          "#{TYPES_NS_ID}:OrganizaceInfo" => {
            "#{TYPES_NS_ID}:NazevOrganizace" => Cssz::Settings.organization_name,
            "#{TYPES_NS_ID}:ICO" => Cssz::Settings.organization_ico
          },
          "#{TYPES_NS_ID}:IdentifikatorDatoveSchranky" => Cssz::Settings.organization_ds_id
        }
      }
    end

    def send_request(request)
      client(request).call(request.soap_method, body: request_payload)
    end

  end
end
