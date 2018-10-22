Rails.application.routes.draw do
  root to: 'information_requests#new'

  resources :information_requests

  mount EgovUtils::Engine => '/internals'
end
