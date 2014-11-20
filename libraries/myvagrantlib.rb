class MyVagrantLib
    def initialize()
      @required_plugins = %w( vagrant-omnibus vagrant-berkshelf vagrant-lxc )
    end 
    def check_plugins
        @required_plugins.each do |plugin|
          if Vagrant.has_plugin? plugin
            puts "vagrant plugin #{plugin} already present"
          else
            system "vagrant plugin install #{plugin}"
          end
        end
    end

    def get_provider
        if ARGV[1] and \
           (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
          provider = (ARGV[1].split('=')[1] || ARGV[2]).to_sym
        else
          provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
        end
        puts "Detected #{provider}"
        return provider
    end
end
