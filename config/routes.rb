Rails.application.routes.draw do


  root to: 'home#get_entry'

  devise_for :admin_uses
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #getでentryがきた場合はhomeのget_entryメソッドにわたす
  get 'entry', :to => 'home#get_entry'

  post 'entry', :to => 'home#post_entry'

end
