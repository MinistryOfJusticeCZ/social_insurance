# Takes in information request made by interaction with the user
# Produces parsed data gathered from the social service B2B services.
class CsszService

  attr_reader :information_request

  def initialize( information_request )
    @information_request = information_request
  end

  # Get data from social service for construction of the final document
  # takes in the request, parses it and decides which services to call.
  def get_cssz_data
    document_data = []
    information_request.insured_people.each_with_index do |person, idx|
      data = {
        'file_uid' => 'XX-XXX-XX/XXXX',
        "person" => {
          'firstname' => person.firstname,
          'lastname' => person.lastname
        }
      }

      req = Cssz::Requests::ZobrazZamestnavatele.new(information_request)
      req.person_index = idx
      req.send
      data = employments_data(req, data)

      if information_request.requested_informations.include?('incapacities')
        req = Cssz::Requests::SeznamPracovnichNeschopnosti.new(information_request)
        req.person_index = idx
        req.send
        data = incapacities_data(req, data)
      else
        data.deep_merge({ 'request' => {'incapacities' => false} })
      end

      if information_request.requested_informations.include?('sickness_benefits')
        req = Cssz::Requests::NemocenskeDavky.new(information_request)
        req.person_index = idx
        req.send
        data = sickness_benefits_data(req, data)
      else
        data.deep_merge({ 'request' => {'sickness_benefits' => false} })
      end

      if information_request.requested_informations.include?('pensions')
        req = Cssz::Requests::NemocenskeDavky.new(information_request)
        req.person_index = idx
        req.send
        data = pensions_data(req, data)
      else
        data.deep_merge({ 'request' => {'pensions' => false} })
      end

      document_data << data
    end

    document_data
  end

  private

    def employments_data(request, data={})
      data.deep_merge({
        'request' => {
          'employments' => true
        },
        'employments' => request.response['employments'],
      })
    end

    def incapacities_data(request, data={})
      data.deep_merge({
        'request' => {
          'incapacities' => true
        },
        'incapacities' => request.response['incapacities']
      })
    end

    def sickness_benefits_data(request, data={})
      data.deep_merge({
        'request' => {
          'sickness_benefits' => true
        },
        'sickness_benefits' => request.response['sickness_benefits']
      })
    end

    def pensions_data(request, data={})
      data.deep_merge({
        'request' => {
          'pensions' => true
        },
        'pensions' => request.response['pensions']
      })
    end

end
