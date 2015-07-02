require 'rbconfig'

class Heroku::JSPlugin
  extend Heroku::Helpers

  def self.setup?
    @is_setup ||= File.exists? bin
  end

  def self.try_takeover(command, args)
    command = command.split(':')
    if command.length == 1
      command = commands.find { |t| t["topic"] == command[0] && t["command"] == nil }
    else
      command = commands.find { |t| t["topic"] == command[0] && t["command"] == command[1] }
    end
    return if !command || command["hidden"]
    run(command['topic'], command['command'], ARGV[1..-1])
  end

  def self.load!
    return unless setup?
    this = self
    topics.each do |topic|
      Heroku::Command.register_namespace(
        :name => topic['name'],
        :description => " #{topic['description']}"
      ) unless Heroku::Command.namespaces.include?(topic['name'])
    end
    commands.each do |plugin|
      help = "\n\n  #{plugin['fullHelp'].split("\n").join("\n  ")}"
      klass = Class.new do
        def initialize(args, opts)
          @args = args
          @opts = opts
        end
      end
      klass.send(:define_method, :run) do
        this.run(plugin['topic'], plugin['command'], ARGV[1..-1])
      end
      Heroku::Command.register_command(
        :command   => plugin['command'] ? "#{plugin['topic']}:#{plugin['command']}" : plugin['topic'],
        :namespace => plugin['topic'],
        :klass     => klass,
        :method    => :run,
        :banner    => plugin['usage'],
        :summary   => " #{plugin['description']}",
        :help      => help,
        :hidden    => plugin['hidden'],
      )
    end
  end

  def self.plugins
    return [] unless setup?
    @plugins ||= `"#{bin}" plugins`.lines.map do |line|
      name, version = line.split
      { :name => name, :version => version }
    end
  end

  def self.is_plugin_installed?(name)
    plugins.any? { |p| p[:name] == name }
  end

  def self.topics
    commands_info['topics']
  rescue
    $stderr.puts "error loading plugin topics"
    return []
  end

  def self.commands
    commands_info['commands']
  rescue
    $stderr.puts "error loading plugin commands"
    # Remove v4 if it is causing issues (for now)
    File.delete(bin) rescue nil
    return []
  end

  def self.commands_info
    @commands_info ||= json_decode(`"#{bin}" commands --json`)
  end

  def self.install(name, opts={})
    self.setup
    system "\"#{bin}\" plugins:install #{name}" if opts[:force] || !self.is_plugin_installed?(name)
  end

  def self.uninstall(name)
    system "\"#{bin}\" plugins:uninstall #{name}"
  end

  def self.update
    system "\"#{bin}\" update"
  end

  def self.version
    `"#{bin}" version`
  end

  def self.bin
    if os == 'windows'
      File.join(Heroku::Helpers.home_directory, ".heroku", "heroku-cli.exe")
    else
      File.join(Heroku::Helpers.home_directory, ".heroku", "heroku-cli")
    end
  end

  def self.setup
    return if File.exist? bin
    $stderr.print "Installing Heroku Toolbelt v4..."
    FileUtils.mkdir_p File.dirname(bin)
    opts = excon_opts.merge(:middlewares => Excon.defaults[:middlewares] + [Excon::Middleware::Decompress])
    resp = Excon.get(url, opts)
    open(bin, "wb") do |file|
      file.write(resp.body)
    end
    File.chmod(0755, bin)
    if Digest::SHA1.file(bin).hexdigest != manifest['builds'][os][arch]['sha1']
      File.delete bin
      raise 'SHA mismatch for heroku-cli'
    end
    $stderr.puts " done"
  end

  def self.run(topic, command, args)
    cmd = command ? "#{topic}:#{command}" : topic
    debug("running #{cmd} on v4")
    exec self.bin, cmd, *args
  end

  def self.arch
    case RbConfig::CONFIG['host_cpu']
    when /x86_64/
      "amd64"
    else
      "386"
    end
  end

  def self.os
    case RbConfig::CONFIG['host_os']
    when /darwin|mac os/
      "darwin"
    when /linux/
      "linux"
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      "windows"
    when /openbsd/
      "openbsd"
    when /freebsd/
      "freebsd"
    else
      raise "unsupported on #{RbConfig::CONFIG['host_os']}"
    end
  end

  def self.manifest
    @manifest ||= JSON.parse(Excon.get("https://d1gvo455cekpjp.cloudfront.net/master/manifest.json", excon_opts).body)
  end

  def self.excon_opts
    if os == 'windows'
      # S3 SSL downloads do not work from ruby in Windows
      {:ssl_verify_peer => false}
    else
      {}
    end
  end

  def self.url
    manifest['builds'][os][arch]['url'] + ".gz"
  end
end
