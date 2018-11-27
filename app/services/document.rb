require 'activeresource'


class Document

  def  self.url(template_id)
    "#{EgovUtils::Settings['ctd_url'] || Rails.configuration.try(:ctd_url)}/api/v1/templates/#{template_id}/documents.json"
  end

  attr_reader :context_data

  def initialize(context_data)
    @context_data = context_data
  end

  def cssz_response(input)
    input.reverse_merge!('document_number' => 'X')
    response = HTTParty.post(self.class.url(2), body: {context: context_data, input: input})
    response.body
  end

end
