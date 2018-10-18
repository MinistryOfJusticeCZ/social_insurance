module Cssz
  class Service

    MESSAGES_NS_ID = 'ikre'
    TYPES_NS_ID = 'ikreTypes'

    def base_url
      'https://10.254.16.169/B2B'
    end

    def base_namespaces
      {"xmlns:#{MESSAGES_NS_ID}"=>"urn:cz:isvs:cssz:schemas:IkreMessages:v1", "xmlns:#{TYPES_NS_ID}"=>"urn:cz:isvs:cssz:schemas:IkrMessageTypes:v1"}
    end

    def client(request)
      Savon.client(
          wsdl: base_url + request.service_path + '?wsdl',
          endpoint: base_url + request.service_path,
          namespace: service_namespace,
          ssl_cert_file: 'ISCSSZ.pem',
          ssl_cert_key_file: 'ISCSSZ_key.pem',
          ssl_cert_key_password: 'iscssz',
          ssl_verify_mode: :none,
          convert_request_keys_to: :camelcase
          #, log: true, log_level: :debug, pretty_print_xml: true
        ) { namespaces base_namespaces }
    end

    def request_payload(request)
      {"#{MESSAGES_NS_ID}:PozadavekHlavicka" => request_head}.merge(request_body)
    end

    def request_head
      {
        "#{MESSAGES_NS_ID}:KodSluzby" => service_code,
        "#{MESSAGES_NS_ID}:PozadavekInfo" => {
          "#{TYPES_NS_ID}:Cas" => Time.now.iso8601,
          "#{TYPES_NS_ID}:DuvodUcel" => 'Nevim',
          "#{TYPES_NS_ID}:Popis" => 'Nevim proc se ptam',
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

  end
end
