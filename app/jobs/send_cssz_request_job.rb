class SendCsszRequestJob < ApplicationJob
  queue_as :default

  def perform(request_id, serialized)
    ir = InformationRequest.find(request_id)
    ir.assign_attributes(serialized)
    requests = []
    ir.insured_people.each_with_index do |person, idx|
      req = Cssz::Requests::ZobrazZamestnavatele.new(ir)
      req.person_index = idx
      req.send
      requests << req
    end

    requests.each do |r|
      file = ir.file_path(r.person_index)
      f_content = Document.new(r).cssz_response({})
      File.open(file, 'w') do |f|
        f.write(Base64.decode64(f_content).force_encoding('UTF-8'))
      end
    end
  end
end
