class InformationRequest < ApplicationRecord

  enum insured_person_type: {individual: 1, mother: 4, father: 8, parents: 12}, _prefix: 'request_for_'

  delegate  'on_day', 'on_day=',
            'insured_people', 'insured_people_attributes=',
            'actual_employments_only', 'actual_employments_only=',
            'request_legitimacy_reason', 'request_legitimacy_reason=',
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

  def file_path(person_index = 0)
    Rails.root.join('storage', "#{id}-#{person_index}.pdf")
  end
end
