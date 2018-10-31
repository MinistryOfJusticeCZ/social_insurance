Rails.application.routes.draw do
  root to: 'information_requests#index'

<<<<<<< HEAD
  resources :information_requests

  resources :information_requests

  mount EgovUtils::Engine => '/internals'

end
