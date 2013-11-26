IndustryMapping::Application.routes.draw do
  resources :emenus

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root :to => "home#index"
  get "industry_sector(.json)" => "sectors#lookup", format: false
end
