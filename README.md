# update ldap dn
Using gitlab with LDAP has one problem. When users moving in Departments or when something causes a change in Distinguished Names, gitlab tends to auto blocks these users.
This is because it queries your AD with the complete DN. Since it changed AD give a negative response. To unblock these users they have to login via the gitlab webfrontend.
Since it uses the credentials to check them in AD and updating the extern_uid afterwards.

With many users this behavior is quiet anoying. Tell each user to login via Webfrontend to get their DN updated in gitlab. I didn't want to notify/update ~130 users so I wrote this.
This rake task queries all active LDAP users, check if they still exists in AD (with the mailaddress) and update extern_uid if it differs from the AD Response.

# usage
## add rake task
```
sudo curl https://raw.githubusercontent.com/derJD/gitlab_update_ldap_dn/master/jd.rake -fo /opt/gitlab/embedded/service/gitlab-rails/lib/tasks/gitlab/jd.rake
```

## run task
```
sudo gitlab-rake gitlab:jd:update_ldap_dn
```

## example

```
:~# sudo gitlab-rake gitlab:jd:update_ldap_dn
User (<username1> / <email1>): [OK]
User (<username2> / <email2>): [WARNING]
cn=<firstname1 lastname1>,ou=old,dc=example,dc=com
cn=<firstname1 lastname1>,ou=new,dc=example,dc=com
[Updated]
.
.
.
```
