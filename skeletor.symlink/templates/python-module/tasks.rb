require 'fileutils'

def clone_skeleton(path)
	system "cd " + path + "
			git clone --recursive ssh://git@github.com/SummitDigital/Skeleton.git ./
			git remote rm origin
			git remote add skeleton ssh://git@github.com/SummitDigital/Skeleton.git"
end

def summit_capify(project_path)
	template_path = File.expand_path('~/.skeletor/templates/summit-skeleton')
	FileUtils.cp(File.join(template_path,'capistrano/Capfile'),project_path)
	FileUtils.cp(File.join(template_path,'capistrano/deploy.rb'),File.join(project_path,'config'))
end