namespace :gitlab do
  namespace :jd do
    desc 'GitLab | jd | update LDAP users DN (use UPDATE_DN="yes" to actualy do it)'
    task update_ldap_dn: :gitlab_environment do

      update_dn = ENV['UPDATE_DN']
      adapter   = Gitlab::Auth::LDAP::Adapter.new('ldapmain')

      User.find_each do |user|
        if user.ldap_user? && user.active?
          print "User (#{user.username} / #{user.email}): "
      
          ad_identity = adapter.user(adapter.config.attributes['email'], user.email)
          unless ad_identity.nil?
            unless (ad_identity.dn == user.ldap_identity.extern_uid)
              user.ldap_identity.extern_uid = ad_identity.dn
              puts "[WARNING]".color(:yellow)
              puts user.ldap_identity.extern_uid_change

              if update_dn == 'yes'
                user.ldap_identity.save!
                puts "[Updated]".color(:green)
              end
            else
              puts "[OK]".color(:green)
            end
          end
        end
      end
    end
  end
end
