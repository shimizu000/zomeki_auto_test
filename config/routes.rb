ZomekiAutoTest::Engine.routes.draw do
  root 'tests#index'
  get 'tests/start' => 'tests#start'
  get 'tests/result' => 'tests#result'
  get 'tests/scenario' => 'tests#scenario'
  get 'tests/detail' => 'tests#detail'
  get 'tests/destroy' => 'tests#destroy'

  resources 'tests', only: :index do
    collection { post :import }
  end
end
