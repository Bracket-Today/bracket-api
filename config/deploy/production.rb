server 'pti-app1.pti-dev.com', user: 'deploy', roles: %w{app db web}
set :delayed_job_workers, 1
set :branch, ENV['BRANCH'] || 'main'

append :linked_files, 'config/credentials/production.key'

set :keyname, 'credentials/production'

after 'delayed_job:restart', 'clockwork:restart'
