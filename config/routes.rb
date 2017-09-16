Rails.application.routes.draw do
  get 'about' => 'welcome#about'

  root 'welcome#index'
end
