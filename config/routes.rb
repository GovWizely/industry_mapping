IndustryMapping::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root :to => "home#index"

  scope "api" do
    get ":model(.json)" => "search#lookup_by_topic", defaults: { format: :json }
  end
end
