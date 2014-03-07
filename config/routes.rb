Snapcard::Application.routes.draw do
  resources :invoices, only: [:new, :create, :show]
  resources :payments, only: [:create]
  get '/payments' => 'payments#create'
end
