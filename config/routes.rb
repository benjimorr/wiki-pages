Rails.application.routes.draw do
  get 'collaborators/index'

  get 'collaborators/update'

  get 'collaborators/destroy'

  resources :charges, only: [:new, :create]
  post 'charges/downgrade', :to => 'charges#downgrade'

  resources :wikis do
      resources :collaborators, only: [:index, :create, :destroy]
  end

  devise_for :users
  get 'about' => 'welcome#about'

  root 'welcome#index'
end
