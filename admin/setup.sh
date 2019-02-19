# Useful commands

# Set the OCP API hostname (master)
MASTER_SVR=https://master.yangon-002b.openshiftworkshop.com

# Set up 100 users: user0 to user99
for i in {0..99}; do useradd user$i \
  -p \
'$6$qmGzVnys$7EGA8ngfhQnHGvNTkeODC6Kw8VvABOYDAfhPua1wSjZJLpDfKi.9g8SAUqLxIyBY5hknSiiXbEZIj5jqgT6Oy.'\
|| break; done

# Log in 100 users
for i in {0..99}; do   su - user$i -c 'oc login --insecure-skip-tls-verify -u user'$i' -p openshift
\
'$MASTER_SVR || break; done

for i in {0..99}; do su - user$i -c 'oc whoami' || break; done

# Delete all
for i in {0..99}; do userdel -r user$i || break; done

# Allow sshd password auth
sed -i "s/^PasswordAuthentication/#PasswordAuthentication/g"  /etc/ssh/sshd_config
systemctl restart sshd

Use the fedora server!
$ sudo dnf install origin-clients docker

