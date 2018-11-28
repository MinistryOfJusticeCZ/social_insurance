class SendCsszRequestJob < ApplicationJob
  queue_as :default

  def perform(request_id, serialized)
    ir = InformationRequest.find(request_id)
    ir.assign_attributes(serialized)
    document_data = []
    ir.insured_people.each_with_index do |person, idx|
      data = {
        "person" => {
          'firstname' => person.firstname,
          'lastname' => person.lastname
        }
      }

      req = Cssz::Requests::ZobrazZamestnavatele.new(ir)
      req.person_index = idx
      req.send
      data = employments_data(req, data)

      if information_request.request_incapacities
        req = Cssz::SeznamPracovnichNeschopnosti.new(ir)
        req.person_index = idx
        req.send
        data = incapacities_data(req, data)
      else
        data.deep_merge({ 'request' => {'incapacities' => false} })
      end

      document_data << data
    end

    document_data.each_with_index do |data, idx|
      file = ir.file_path(idx)
      f_content = Document.new(data).cssz_response({})
      File.open(file, 'wb') do |f|
        f.write(f_content)
      end
    end
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
          'incapacities' => !!information_request.request_incapacities
        },
        'incapacities' => request.response['incapacities']
      })
    end
end
