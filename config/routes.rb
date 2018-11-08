Rails.application.routes.draw do
  root to: 'information_requests#index'

  resources :information_requests

  mount EgovUtils::Engine => '/internals'


  require 'sidekiq/api'
  get "sidekiq-status" => proc { [200, {"Content-Type" => "text/plain"}, [Sidekiq::Queue.new.size < 50 ? "OK" : "UHOH" ]] }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
