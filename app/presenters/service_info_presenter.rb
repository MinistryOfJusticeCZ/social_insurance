class ServiceInfoPresenter
  class ServiceContactsPresenter
    attr_accessor :helpdesk, :service_owner
  end

  attr_accessor :name, :path

  def purposes
    @purposes ||= []
  end

  def description
    @description_lines ||= []
  end

  def contacts
    @contacts ||= ServiceContactsPresenter.new
  end

  def prerequisities
    @prerequisities ||= []
  end

  def load(payload)
    self.name = payload['name']
    self.path = payload['path']
    payload['purposes'].each do |p|
      purposes.push(p)
    end
    payload['description'].each do |p|
      description.push(p)
    end
    payload['prerequisities'].each do |p|
      prerequisities.push(p)
    end
    contacts.helpdesk = payload['contacts']['helpdesk']
  end

end
