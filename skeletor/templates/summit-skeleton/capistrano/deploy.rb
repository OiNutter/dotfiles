# What is the name of the local application?
set :application, "<SITE URL HERE>"

# What user is connecting to the remote server?
set :user, "root"
 
# Where is the local repository?
set :repository, "file:///home/<FTP USERNAME HERE>/git/<REPOSITORY NAME HERE>.git"
set :local_repository,  " ssh://vserver/home/<FTP USERNAME HERE>/git/<REPOSITORY NAME HERE>.git"

# What is the production server domain?
role :web, "vserver"

# What remote directory hosts the production website?
set :deploy_to,   "/home/<FTP USERNAME HERE>/public_html/"

# Is sudo required to manipulate files on the remote server?
set :use_sudo, false
 
# What version control solution does the project use?
set :scm,        :git
set :branch,     'master'

# How are the project files being transferred?
set :deploy_via, :remote_cache

# Maintain a local repository cache. Speeds up the copy process.
set :copy_cache, true

# Ignore any local files?
set :copy_exclude, %w(.git,deployment,.project)

#enabled submodules
set :git_enable_submodules, 1

set :group_writable, false

ssh_options[:forward_agent] = true

after "deploy:setup", "summit:change_permissions", "summit:upload_global_htaccess", "summit:create_shares"

after "deploy", "summit:switch_htaccess","summit:link_admin_config", "summit:change_permissions"
after "deploy:rollback", "summit:change_permissions"

namespace :summit do 
	#creates git repository on server
  task :create_git_repo, :roles => :web do
    
    run 'mkdir /home/<FTP USERNAME HERE>/git && git init --bare /home/<FTP USERNAME HERE>/git/<REPOSITORY NAME HERE>.git'
    system 'git remote add origin ssh://vserver/home/<FTP USERNAME HERE>/git/<REPOSITORY NAME HERE>.git'
  end
  

  #generates default htaccess file to redirect to current
  task :upload_global_htaccess, :roles =>:web do
    upload(".htaccess-global","#{deploy_to}.htaccess",:via=>:scp, :mod=>'755')
  end
  
  #create required shared folders
  task :create_shares, :roles=>:web do
    run 'mkdir /home/<FTP USERNAME HERE>/www/shared/uploads && sudo chmod 777 /home/<FTP USERNAME HERE>/www/shared/uploads'
    run 'mkdir /home/<FTP USERNAME HERE>/www/shared/batches && sudo chmod 777 /home/<FTP USERNAME HERE>/www/shared/batches'
    run 'mkdir /home/<FTP USERNAME HERE>/www/shared/config'
  end

  #update the permissions
  task :change_permissions, :roles => :web do
	run "sudo chown -R <FTP USERNAME HERE>:<FTP USERNAME HERE> #{deploy_to}current"
	run "sudo chown -R <FTP USERNAME HERE>:<FTP USERNAME HERE> #{current_release}"
    run "sudo chmod 755 #{deploy_to}"
    run "sudo chmod -R 755 #{current_release}"
  end

  #link the admin config file
  task :link_admin_config do
    run "ln -s -f #{shared_path}/configs/admin-config.json #{current_release}/admin/config/site/config.json"
  end

  #upload the admin config files
  task :put_admin_config do
    if(File.exists?("admin/config/site/config.json"))
      upload("admin/config/site/config.json","#{shared_path}/configs/admin-config.json",:via => :scp, :mode => '755')
      puts 'Admin config uploaded'
    else
      puts 'No JSON File To Upload'
    end
    
    if(File.exists?("admin/app/assets/css/sass/_colours.scss"))
      upload("admin/app/assets/css/sass/_colours.scss","#{shared_path}/configs/admin-colours.scss",:via => :scp, :mode => '755')
      puts 'Admin CSS constants uploaded'
    else
      puts 'No SASS File To Upload'
    end
  end

  #downloads the admin config files
  task :get_admin_config do
    download("#{shared_path}/configs/admin-config.json","admin/config/site/config.json",:via => :scp)
    download("#{shared_path}/configs/admin-colours.scss","admin/app/assets/css/sass/_colours.scss",:via => :scp)
  end

  #deploys admin config files
  task :deploy_admin_config do
    put_admin_config
    link_admin_config
  end

  #replaces development htaccess with production version
  task :switch_htaccess, :roles => :web do
    run "mv #{current_release}/.htaccess #{current_release}/.htaccess-development"
    run "cp #{current_release}/.htaccess-production #{current_release}/.htaccess"
  end
  
end
