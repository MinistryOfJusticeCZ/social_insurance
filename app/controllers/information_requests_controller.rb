class InformationRequestsController < ApplicationController

  def index
  end

  def new
    @information_request = InformationRequest.new
  end

  def create
  end

  private
    def create_params
      params.require(:information_request).
        permit(:firstname, :lastname, :birth_date, :birth_number, :birth_lastname, :on_day, :actual_employments_only, :request_legitimacy_reason)
    end

end
