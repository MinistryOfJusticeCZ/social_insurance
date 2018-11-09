class InformationRequestsController < ApplicationController

  # load_and_authorize_resource

  def index
    @info = ServiceInfoPresenter.new
    info_payload = YAML.load(File.read(Rails.root.join('config', 'cssz_info.yml')))
    info_payload['path'] = new_information_request_path
    @info.load(info_payload)
  end

  def show
    @information_request = InformationRequest.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf{ send_file @information_request.file_path }
    end
  end

  def new
    @information_request = InformationRequest.new
    @information_request.assign_attributes(prepare_params)
    @pages = pages
  end

  def create
    @information_request = InformationRequest.new
    @information_request.assign_attributes(prepare_params)
    @pages = pages
    if !@pages.last_page? || !@pages.confirmed?
      @pages.next_page! if @pages.current_valid?
      render 'new'
    else
      attrs = session.delete(:information_request)
      @information_request.save
      SendCsszRequestJob.perform_later(@information_request.id, attrs)
      redirect_to @information_request
    end
  end

  private
    def prepare_params
      session[:information_request] ||= {}
      session[:information_request].merge!(create_params) if params['information_request']
      session[:information_request]
    end

    def create_params
      params.require(:information_request).
        permit(
          :insured_person_type,
          :on_day, :actual_employments_only,
          :request_legitimacy_reason,
          insured_people_attributes: [
            :firstname, :lastname,
            :birth_date, :birth_number,
            :birth_lastname
          ]
        )
    end

    def pages
      InformationRequestPagesPresenter.new(
        @information_request,
        page_number: params['page_number'],
        confirmed: !!params['confirmation_page']
      )
    end

end
