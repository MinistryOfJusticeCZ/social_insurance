class InformationRequest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Attributes

  attribute :firstname, :string
  attribute :lastname, :string
  attribute :birth_date, :date
  attribute :birth_number, :string
  attribute :birth_lastname, :string

  attribute :on_day, :date
  attribute :actual_employments_only, :boolean #only actual employments
  attribute :request_legitimacy_reason, :string

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
