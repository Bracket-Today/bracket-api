lock '~> 3.15.0'

set :application, 'bracket-api'
set :repo_url, 'git@github.com:Bracket-Today/bracket-api.git'

set :clockwork_file, 'config/clock.rb'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
  'vendor/bundle', '.bundle', 'public/system', 'storage'

set :migration_role, :app
set :keep_releases, 3

set :clockwork_default_hooks, false
