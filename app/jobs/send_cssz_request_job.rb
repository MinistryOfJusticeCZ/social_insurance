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
      file = Rails.root.join('storage', "#{request_id}-#{r.person_index}.pdf")
      File.open(file, 'w') do |f|
        f.write(Document.new(r).cssz_response({}))
      end
    end
  end
end
