# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

Rails.application.config.assets.precompile += %w( style.css )
Rails.application.config.assets.precompile += %w( app.css )
Rails.application.config.assets.precompile += %w( admin_style.css )
Rails.application.config.assets.precompile += %w( admin/admin.js )
Rails.application.config.assets.precompile += %w( admin/adminAngular.js )
Rails.application.config.assets.precompile += %w( animate.css )
Rails.application.config.assets.precompile += %w( typography.css )

Rails.application.config.assets.precompile += %w( base_app.js )
Rails.application.config.assets.precompile += %w( base_angular_app.js )
Rails.application.config.assets.precompile += %w( dropin_finder_app.js )

Rails.application.config.assets.precompile += %w( scrape/scrape.js )

Rails.application.config.assets.paths += %w( templates )

