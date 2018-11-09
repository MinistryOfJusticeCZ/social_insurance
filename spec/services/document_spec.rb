require 'rails_helper'

RSpec.describe Document do
  it 'calls http_party' do
    response_double = double('response')
    request = instance_double('Cssz::Requests::ZobrazZamestnavatele')
    person_data = double('person_data', firstname: 'assadf', lastname: 'asdfasdf')

    allow(request).to receive(:person_data).and_return(person_data)
    allow(request).to receive(:response).and_return({'employments' => []})
    allow(Document).to receive(:url).with(2).and_return('http://test/api/v1/templates/1/documents')
    expect(HTTParty).to receive(:post).and_return(response_double)
    expect(response_double).to receive(:body)


    Document.new(request).cssz_response({})
  end
end
