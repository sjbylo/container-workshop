# Useful commands

# Update

dnf -y update 

# Install oc 
dnf -y install origin-clients podman git

# Set the OCP API hostname (master)
MASTER_SVR=https://master.yangon-002b.openshiftworkshop.com

# Set up 200 users: user0 to user199
for i in {0..199}; do echo user$i; useradd user$i -p '$6$qmGzVnys$7EGA8ngfhQnHGvNTkeODC6Kw8VvABOYDAfhPua1wSjZJLpDfKi.9g8SAUqLxIyBY5hknSiiXbEZIj5jqgT6Oy.' || break; done

# Log in all users
for i in {0..199}; do echo user$i; su - user$i -c 'oc login --insecure-skip-tls-verify -u user'$i' -p openshift '$MASTER_SVR || break; done

# Verify login
for i in {0..199}; do echo user$i; su - user$i -c 'oc whoami' || break; done

# Delete all user projects!
echo "for p in \$(oc projects -q); do oc delete project \$p; done" > /usr/bin/ocp-delete-all-proj
for i in {0..199}; do echo user$i; su - user$i -c 'bash /usr/bin/ocp-delete-all-proj' || break; done

# Delete all users
for i in {0..199}; do echo user$i; userdel -r user$i || break; done

# Allow sshd password auth
sed -i "s/^PasswordAuthentication/#PasswordAuthentication/g"  /etc/ssh/sshd_config
systemctl restart sshd


