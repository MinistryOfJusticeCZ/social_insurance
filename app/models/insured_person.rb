class InsuredPerson
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment

  attribute :firstname, :string
  attribute :lastname, :string
  attribute :birth_date, :date
  attribute :birth_number, :string
  attribute :birth_lastname, :string

end
