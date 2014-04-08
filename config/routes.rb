Ilmoprojekti::Application.routes.draw do
  resources :students

  resources :projectbundles

  resources :signups

  resources :projects

  resources :users

  resources :enrollments

  resources :sessions, only: [:new, :create, :destroy]

  get 'projectbundles/:projectbundle_id/verify', to: 'projectbundles#verify'
  get 'all', to: 'enrollments#index'
  get 'enrollments/:enrollment_id/:hash', to: 'enrollments#edithash'
  delete 'enrollments/:enrollment_id/delete', to: 'enrollments#destroy'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  post 'setstatus', to: 'enrollments#setstatus'
  get 'getstatus/:enrollment_id/:project_id', to: 'enrollments#getstatus'
  post 'setforced', to: 'enrollments#setforced'
  get 'getstatuses', to: 'enrollments#get_statuses'
  get 'getsummaries', to: 'enrollments#get_summaries'
  get 'tabledata', to: 'enrollments#get_current_statuses'

  root 'enrollments#new'

  get 'emails', to: 'enrollments#show_emails'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#new'

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
