require 'activeresource'


class Document

  def  self.url(template_id)
    "#{EgovUtils::Settings['ctd_url'] || Rails.configuration.try(:ctd_url)}/api/v1/templates/#{template_id}/documents.json"
  end

  attr_reader :request

  def initialize(request)
    @request = request
  end

  def context_data
    {
      "person" => {
        request.data.person_data.firstname,
        request.data.person_data.lastname,
      },
      'employments' => request.response['employments']
    }
  end

  def cssz_response(input)
    input.reverse_merge!('document_number' => 'X')
    response = HTTParty.post(self.class.url(2), body: {context: context_data, input: input})
    response.body
  end

end
