SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :information_request, InformationRequest.new.model_name.human, new_information_request_path
  end
end
