class RequestData
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment

  attribute :on_day, :date
  attribute :actual_employments_only, :boolean #only actual employments
  attribute :request_legitimacy_reason, :string

  def insured_people
    @insured_people ||= []
  end

  def insured_people_attributes=(attrs)
    @insured_people = []
    attrs = attrs.values if attrs.is_a?(Hash)
    attrs.each do |person_attrs|
      pers = InsuredPerson.new
      pers.assign_attributes(person_attrs)
      insured_people << pers
    end
  end

  def serialize
    {
      'on_day' => on_day,
      'insured_people_attributes' => insured_people.collect{|ip| ip.attributes }
    }
  end
end
