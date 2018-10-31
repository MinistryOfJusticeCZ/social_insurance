class InformationRequestsController < ApplicationController

  def index
    @info = ServiceInfoPresenter.new
    info_payload = YAML.load(File.read(Rails.root.join('config', 'cssz_info.yml')))
    info_payload['path'] = new_information_request_path
    @info.load(info_payload)
  end

  def new
    @information_request = InformationRequest.new
    @pages = InformationRequestPagesPresenter.new(@information_request)
  end

  def create
  end

  private
    def create_params
      params.require(:information_request).
        permit(:firstname, :lastname, :birth_date, :birth_number, :birth_lastname, :on_day, :actual_employments_only, :request_legitimacy_reason)
    end

end
