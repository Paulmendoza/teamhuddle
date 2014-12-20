Rails.application.routes.draw do

  get 'contact_us/new'

  devise_for :admins, :controllers => { :registrations => :registrations }
  as :admin do
    get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
    put 'admins' => 'devise/registrations#update', :as => 'admin_registration'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'index#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'admin' => 'admin#index'
  
  post 'contact_us' => 'contact_us#create'
  post 'users' => 'users#create'

  # basic routes
  get 'contact' => 'index#contact'
  get 'about' => 'index#about'
  get 'dropin-finder' => 'index#dropin_finder'
  
  scope :admin do
    resources :locations
    resources :organizations
    resources :dropins do
      member do
        get 'renew'
      end

      collection do
        get 'import'
        post 'scrape'
        post 'duplicate'
      end
    end
    get 'contact_us' => 'contact_us#index'
    get 'admin_stats' => 'admin#admin_stats'
    get 'admin_signed_in' => 'admin#admin_signed_in'
  end
  
  # aliases of sport_event
  scope :api, defaults: { format: 'json' } do
    scope :v1 do
      resources :api_dropins, only: [:index]
    end
  end

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  
  
  


end
