ZomekiAutoTest::Engine.routes.draw do
  root 'tests#index'
  resource :tests
  get 'tests/start' => 'tests#start'
  post 'tests/start' => 'tests#start'
end
