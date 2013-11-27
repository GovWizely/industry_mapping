IndustryMapping::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root :to => "home#index"
  get "industry_sector(.json)" => "sectors#lookup", defaults: { format: :json }
end
