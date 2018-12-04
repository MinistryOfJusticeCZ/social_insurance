class SendCsszRequestJob < ApplicationJob
  queue_as :default

  def perform(request_id, serialized)
    ir = InformationRequest.find(request_id)
    ir.assign_attributes(serialized)

    document_data = CsszService.new(ir)

    document_data.each_with_index do |data, idx|
      file = ir.file_path(idx)
      f_content = Document.new(data).cssz_response({})
      File.open(file, 'wb') do |f|
        f.write(f_content)
      end
    end
  end

end
