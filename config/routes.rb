Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #getでentryがきた場合はhomeのget_entryメソッドにわたす
  get 'entry', :to => 'home#get_entry'

  post 'entry', :to => 'home#post_entry'

end
