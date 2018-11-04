class InformationRequest < ApplicationRecord

  enum insured_person_type: {individual: 1, mother: 4, father: 8, parents: 12}, _prefix: 'request_for_'

  delegate  'on_day', 'on_day=',
            'insured_people', 'insured_people_attributes=',
            to: :request_data

  def request_data
    @request_data ||= RequestData.new
  end

  def reason
    'Some default reason'
  end

  def reason_description
    'Reason longer description'
  end
end
