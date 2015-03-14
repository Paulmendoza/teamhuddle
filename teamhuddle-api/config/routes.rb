Rails.application.routes.draw do

  # These are the routes for users
  devise_for :users,
             :module => "users",
             :format => false

  devise_scope :user do
    post "/logout" => "users/sessions#destroy", :as => :destroy_user_session_post
    get "/profile" => "users/profiles#profile", :as => :user_profile
    get "/player/:id" => "users/profiles#player", :as => :player_profile

    get "/users/is_signed_in" => "users/sessions#is_signed_in"
  end

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
  post 'beta_testers' => 'beta_testers#create'

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
        get 'scrape' => 'scrape#index'
        post 'duplicate'
        post 'refresh_inactive_dropins'
      end
    end

    scope :scrape do
      get 'get-data' => 'scrape#get_data'
      get 'get-ids-by-category/:id' => 'scrape#get_ids_by_category'

      post 'get-dropins-by-ids' => 'scrape#get_dropins_by_ids'
    end

    get 'contact_us' => 'contact_us#index'
    get 'admin_stats' => 'admin#admin_stats'
    get 'admin_signed_in' => 'admin#admin_signed_in'
  end

  # aliases of sport_event
  scope :api, defaults: { format: 'json' } do
    scope :v1 do
      get '/api_dropins' => 'api_dropins#index'
      get '/api_dropins/sport_event/:id' => 'api_dropins#show'
    end
  end

  resources :reviews, :only => [:index, :create, :show]

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
