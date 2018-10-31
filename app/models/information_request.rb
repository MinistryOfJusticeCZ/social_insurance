class InformationRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Attributes

  attribute :insured_person_type

  attribute :on_day, :date
  attribute :actual_employments_only, :boolean #only actual employments
  attribute :request_legitimacy_reason, :string

  def insured_people
    @insured_people ||= []
  end

  def insured_people_attributes=(attrs)
    @insured_people = []
    attrs = attrs.keys if attrs.is_a?(Hash)
    attrs.each do |person_attrs|
      insured_people << InsuredPerson.new(person_attrs)
    end
  end

  def reason
    'Some default reason'
  end

  def reason_description
    'Reason longer description'
  end

  def persisted?
    false
  end
end
