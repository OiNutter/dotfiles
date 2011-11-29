require 'rake'

DIRS_TO_SYMLINK = ['ssh','skeletor','heroku','bin','vim']
$skip_all = false
$overwrite_all = false
$backup_all = false

desc "Generates a symlink"
def link_file(file,path)
	
	overwrite = false
    backup = false
	
	target = "#{ENV["HOME"]}/.#{file}"

    if File.exists?(target) || File.symlink?(target)
      unless $skip_all || $overwrite_all || $backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
		when 'o' then overwrite = true
		when 'b' then backup = true
		when 'O' then $overwrite_all = true
		when 'B' then $backup_all = true
		when 'S' then $skip_all = true
		when 's' then return
		end
      end
      FileUtils.rm_rf(target) if overwrite || $overwrite_all
      `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || $backup_all
    end
    `ln -s "$PWD/#{path}" "#{target}"`
	
end

desc "Hook our dotfiles into system-standard positions."
task :install do
  linkables = Dir.glob('*/**{.symlink}')

  linkables.each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    
	link_file file, linkable
	
  end
  
  DIRS_TO_SYMLINK.each do |directory|
	dir = directory.split('/').last
	link_file dir, directory
  end
end

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end
    
    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"` 
    end

  end
end

task :default => 'install'