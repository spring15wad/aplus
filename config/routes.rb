Rails.application.routes.draw do
  root 'welcome#welcome'
  get 'menu' => 'menu#menu'

  get 'share_request/new/:type/:oid/:name' => 'share_request#new', as: :share_request_new
  post 'share_requests/:type/:oid/:name' => 'share_request#create', as: :share_requests
  get 'share_request/share/:id' => 'share_request#share', as: :share_request_share
  get 'share_request/notify' => 'share_request#notify', as: :share_request_notify
  delete 'share_request/destroy/:id' => 'share_request#destroy', as: :share_request_destroy

  get 'filter_subject' => 'application#filter_subject'
  get 'todays_study' => 'review_box#todays_study'
  get 'weeks_study' => 'review_box#weeks_study'

  resources :subjects do
    patch 'archive' => 'subjects#archive', as: :archive
  end

  resources :topics do
    resources :cards
    get 'set_review' => 'review_box#set_review', as: :prepare_review
    get 'review_box/:b' => 'review_box#review_box', as: :review_box
    get 'review_box/:b/card/:card_id/front/' => 'review_box#front', as: :card_front
    get 'review_box/:b/card/:card_id/back/' => 'review_box#back', as: :card_back
    post 'review_box/:b/card/:card_id/answer' => 'review_box#answer', as: :card_answer
    patch 'reset_cards' => 'topics#reset_cards', as: :reset_cards
    patch 'set_reviewing' => 'topics#set_reviewing', as: :set_review
  end

  get '/auth/:provider', to: lambda{|env| [404, {}, ["Not Found"]]}, as: 'login'
  get '/auth/:provider/callback', to: 'session#create'
  get '/logout', to: 'session#destroy', as: 'logout'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
