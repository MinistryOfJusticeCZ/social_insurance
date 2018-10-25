Rails.application.routes.draw do
  root to: 'information_requests#index'

  resources :information_requests

  mount EgovUtils::Engine => '/internals'
end
