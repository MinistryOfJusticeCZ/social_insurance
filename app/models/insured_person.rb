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
  attribute :birth_place, :string

  def assign_attributes(attrs)
    attrs = attrs.stringify_keys
    birth_date_ks = attrs.keys.select{|k| k.starts_with?('birth_date')}
    if birth_date_ks.include?('birth_date')
      birth_date_ks.each{|k| attrs.delete(k) if k != 'birth_date'}
    elsif birth_date_ks.size >= 3
      bd = {}
      birth_date_ks.each do |k|
        bd[k[-3].to_i] = attrs.delete(k).to_i
      end
      attrs['birth_date'] = Date.civil(bd[1], bd[2], bd[3])
    end
    super(attrs)
  end

end
