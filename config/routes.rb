ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  #map.connect '/', :controller => 'home', :action => 'index'
  map.root :controller => 'home'
  map.onlineapplications '/onlineapplications', :controller => 'olservs', :action => 'onlineapplications'
  map.onlinesrvs '/onlinesrvs', :controller => 'olservs', :action => 'onlinesrvs'
  map.regulatione '/regulatione', :controller => 'olservs', :action => 'regulatione'
  map.cufees '/cufees', :controller => 'olservs', :action => 'cufees'
  map.infodesk '/infodesk', :controller => 'olservs', :action => 'infodesk'
  
  map.links '/links', :controller => 'home', :action => 'links'
  map.contact '/contact', :controller => 'home', :action => 'contact'
  map.lostcards '/lostcards', :controller => 'home', :action => 'lostcards'
  map.privacy '/privacy', :controller => 'home', :action => 'privacy'
  map.memberjoin '/memberjoin', :controller => 'home', :action => 'memberjoin'
  map.faq '/faq', :controller => 'home', :action => 'faq'
  map.transfer '/transfer', :controller => 'home', :action => 'transfer'
  map.realestate '/realestate', :controller => 'home', :action => 'realestate'
  map.aboutus '/aboutus', :controller => 'home', :action => 'aboutus'
  map.whatsnew '/whatsnew', :controller => 'home', :action => 'whatsnew'
  map.scams '/scams', :controller => 'home', :action => 'scams'
  map.estatements '/estatements', :controller => 'home', :action => 'estatements'  
  
  map.calculates '/calculates', :controller => 'calculate', :action => 'calculates'
  map.savcalc '/savcalc', :controller => 'calculate', :action => 'savcalc'
  map.savcalcr '/savcalcr', :controller => 'calculate', :action => 'savcalcr'
  map.loancalc '/loancalc', :controller => 'calculate', :action => 'loancalc'
  map.loancalcr '/loancalcr', :controller => 'calculate', :action => 'loancalcr'
  map.fixedmortgage '/fixedmortgage', :controller => 'calculate', :action => 'fixedmortgage'
  map.fixedmortgager '/fixedmortgager', :controller => 'calculate', :action => 'fixedmortgager'
  map.schelp '/schelp', :controller => 'calculate', :action => 'schelp'
  
  map.rate 'rate', :controller => 'rates', :action => 'rate'
  
  map.prodservices 'prodservices', :controller => 'productnservices', :action => 'prodservices'
  map.repos 'repos', :controller => 'productnservices', :action => 'repos'
  map.newsletter 'newsletter', :controller => 'productnservices', :action => 'newsletter'
end
