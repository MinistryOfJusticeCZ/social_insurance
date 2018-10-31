class InformationRequestsController < ApplicationController

  # load_and_authorize_resource

  def index
    @info = ServiceInfoPresenter.new
    info_payload = YAML.load(File.read(Rails.root.join('config', 'cssz_info.yml')))
    info_payload['path'] = new_information_request_path
    @info.load(info_payload)
  end

  def new
    @information_request = InformationRequest.new
    @pages = pages
  end

  def create
    @information_request = InformationRequest.new
    create_params.each do |attr, value|
      @information_request.send("#{attr}=", value)
    end
    @pages = pages
    if !@pages.last_page?
      @pages.next_page! if @pages.current_valid?
      render 'new'
    else
      @information_request.save
    end
  end

  private
    def create_params
      params.require(:information_request).
        permit(:firstname, :lastname, :birth_date, :birth_number, :birth_lastname, :on_day, :actual_employments_only, :request_legitimacy_reason)
    end

    def pages
      InformationRequestPagesPresenter.new(@information_request)
    end

end
