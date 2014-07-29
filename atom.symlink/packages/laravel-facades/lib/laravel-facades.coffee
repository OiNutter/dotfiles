module.exports =
  facades: ->
    "App": "Foundation/Application.php"
    "Artisan": "Foundation/Artisan.php"
    "Auth": "Auth/Guard.php"
    "Blade": "View/Compilers/BladeCompiler.php"
    "Cache": "Cache/Repository.php"
    "Config": "Config/Repository.php"
    "Cookie": "Cookie/CookieJar.php"
    "Crypt": "Encryption/Encrypter.php"
    "DB": "Database/DatabaseManager.php"
    "Event": "Events/Dispatcher.php"
    "File": "Filesystem/Filesystem.php"
    "Form": "Html/FormBuilder.php"
    "Hash": "Hashing/BcryptHasher.php"
    "HTML": "Html/HtmlBuilder.php"
    "Input": "Http/Request.php"
    "Lang": "Translation/Translator.php"
    "Log": "Log/Writer.php"
    "Mail": "Mail/Mailer.php"
    "Paginator": "Pagination/Environment.php"
    "Password": "Auth/Reminders/PasswordBroker.php"
    "Queue": "Queue/QueueManager.php"
    "Redirect": "Routing/Redirector.php"
    "Redis": "Redis/Database.php"
    "Request": "Http/Request.php"
    "Response": "Support/Facades/Response.php"
    "Route": "Routing/Router.php"
    "Schema": "Database/Schema/Blueprint.php"
    "Session": "Session/Store.php"
    "SSH": "Remote/Connection.php"
    "URL": "Routing/UrlGenerator.php"
    "Validator": "Validation/Factory.php"
    "View": "View/Environment.php"

  activate: (state) ->
    facades = @facades()
    facadeKeys = Object.keys(facades).sort()

    for facade in facadeKeys
      file = facades[facade]
      do (file) =>
        atom.workspaceView.command "laravel-facades:#{facade}", => @openFacade(file)

  openFacade: (file) ->
    projectRootPath = atom.project.path
    laravelPath = "vendor/laravel/framework/src/Illuminate/"
    fullFilePath = "#{projectRootPath}/#{laravelPath}#{file}"
    atom.workspace.open fullFilePath
