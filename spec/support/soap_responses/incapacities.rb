module SoapResponses
  class Incapacities

    attr_accessor :information_request

    def initialize(ir)
      @information_request = ir
    end

    def person(idx=0)
      information_request.insured_people[idx]
    end

    def xml
      <<-XML
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                    xmlns:urn="urn:cz:isvs:cssz:schemas:IkreZobrazSeznamPNPojistence:v1"
                    xmlns:urn1="urn:cz:isvs:cssz:schemas:IkreMessages:v1"
                    xmlns:urn2="urn:cz:isvs:cssz:schemas:IkrMessageTypes:v1">
    <soapenv:Header/>
    <soapenv:Body>
      <urn:IkreZobrazSeznamPNPojistenceOdpoved verzeSluzby="?">
         <urn1:OdpovedHlavicka>
            <urn1:KodSluzby>IkreZobrazSeznamPNPojistence</urn1:KodSluzby>
            <urn1:PozadavekInfo>
               <urn2:Cas>?</urn2:Cas>
               <!--Optional:-->
               <urn2:DuvodUcel>AAAA</urn2:DuvodUcel>
               <urn2:Popis>AAbaddf asdfsdf</urn2:Popis>
               <urn2:VstupniKanalId>B2B</urn2:VstupniKanalId>
               <urn2:PozadovanyVystupniKanalId>B2B</urn2:PozadovanyVystupniKanalId>
            </urn1:PozadavekInfo>
            <urn1:KlientInfo>
               <urn2:TypKlienta>OVM</urn2:TypKlienta>
               <urn2:KlientId>MSP</urn2:KlientId>
               <!--Optional:-->
               <!--urn2:JmenoUzivatele>?</urn2:JmenoUzivatele-->
               <!--Optional:-->
               <urn2:OrganizaceInfo>
                  <urn2:NazevOrganizace>Ministerstvo spravedlnosti</urn2:NazevOrganizace>
                  <!--Optional:-->
                  <urn2:ICO>021546554</urn2:ICO>
               </urn2:OrganizaceInfo>
               <!--Optional:-->
               <urn2:IdentifikatorDatoveSchranky>klsdaf</urn2:IdentifikatorDatoveSchranky>
            </urn1:KlientInfo>
            <urn1:OdpovedInfo>
               <urn2:Cas>?</urn2:Cas>
               <urn2:Status>
                  <urn2:VysledekKod>OK</urn2:VysledekKod>
               </urn2:Status>
               <!--Optional:-->
               <urn2:PozadavekId>?</urn2:PozadavekId>
               <!--Optional:-->
               <urn2:OdpovedId>?</urn2:OdpovedId>
            </urn1:OdpovedInfo>
            <urn1:JednotneEvidencniCislo>?</urn1:JednotneEvidencniCislo>
         </urn1:OdpovedHlavicka>
         <urn2:AplikacniStatus>
            <urn2:VysledekKod>OK</urn2:VysledekKod>
         </urn2:AplikacniStatus>
         <!--Optional:-->
         <urn:OdpovedData>
            <urn:Pojistenec>
               <!--You have a CHOICE of the next 2 items at this level-->
               <!--urn2:EvidencniCisloPojistence>?</urn2:EvidencniCisloPojistence-->
               <urn2:RodneCislo>#{person.birth_number}</urn2:RodneCislo>
               <urn2:PojistenecId>?</urn2:PojistenecId>
               <urn2:Jmeno>#{person.firstname}</urn2:Jmeno>
               <urn2:Prijmeni>#{person.lastname}</urn2:Prijmeni>
            </urn:Pojistenec>
            <!--Zero or more repetitions:-->
            <urn:PracovniNeschopnost>
               <!--Optional:-->
               <urn2:CisloRozhodnuti>152645</urn2:CisloRozhodnuti>
               <urn2:ZacatekPracovniNeschopnosti>2018-11-04</urn2:ZacatekPracovniNeschopnosti>
               <!--Optional:-->
               <urn2:KonecPracovniNeschopnosti>2018-11-19</urn2:KonecPracovniNeschopnosti>
               <!--Optional:-->
               <urn2:DelkaPripadu>15</urn2:DelkaPripadu>
            </urn:PracovniNeschopnost>
         </urn:OdpovedData>
      </urn:IkreZobrazSeznamPNPojistenceOdpoved>
    </soapenv:Body>
  </soapenv:Envelope>
      XML
    end

  end
end
