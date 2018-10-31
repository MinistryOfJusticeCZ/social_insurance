Rails.application.routes.draw do
  root to: 'information_requests#index'

  get 'information_requests/step-one', to: 'information_requests#step-one', as: 'step-one'
  get 'information_requests/step-two', to: 'information_requests#step-two', as: 'step-two'
  get 'information_requests/step-two-father', to: 'information_requests#step-two-father', as: 'step-two-father'
  get 'information_requests/step-three', to: 'information_requests#step-three', as: 'step-three'
  get 'information_requests/step-four', to: 'information_requests#step-four', as: 'step-four'
  get 'information_requests/step-five', to: 'information_requests#step-five', as: 'step-five'
  resources :information_requests

  mount EgovUtils::Engine => '/internals'

end
