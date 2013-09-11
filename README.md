##Wikenso [![Build Status](https://travis-ci.org/nilenso/wikenso.png?branch=master)](https://travis-ci.org/nilenso/wikenso)

Clean and simple wiki hosting.

#### Developer Setup

##### Ubuntu

- Install Ruby 2.0.0

```bash
$ sudo apt-get install git
$ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
$ echo 'eval "$(rbenv init -)"' >> ~/.profile
$ exec $SHELL -l
$ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
$ sudo apt-get install make
$ rbenv install 2.0.0-p247
$ rbenv global 2.0.0p-247
```

- Install Postgres

```bash
$ sudo apt-get update
$ sudo apt-get install postgresql postgresql-contrib libpq-dev
```

- Fix Postgres Locale Issue

```bash
$ touch ~/.bash_profile
$ echo "export LC_ALL=\"en_US.UTF-8\"" >> ~/.profile
$ source ~/.profile
$ sudo pg_dropcluster --stop 9.1 main
$ sudo pg_createcluster --start -e UTF-8 9.1 main
```

- Initialize Postgres

```bash
$ sudo -u postgres createuser --superuser $USER
$ sudo -u postgres psql postgres
```


- Inside the Postgres console

```psql
postgres=# \password vagrant # This guide assumes the password is 'vagrant'
postgres=# \q
```

- Configure Postgres

```bash
$ createdb vagrant
$ sudo apt-get install vim
$ sudo vim /etc/postgresql/9.1/main/postgresql.conf # Uncomment the line containing this – `listen_addresses = 'localhost'`
$ sudo vim /etc/postgresql/9.1/main/pg_hba.conf # Under '"local" is for Unix domain socket connections only' change `peer` to `md5`
```

- Start Postgres

```bash
$ sudo /etc/init.d/postgresql restart
```

- Bundle gems

```bash
$ cd /vagrant
$ gem install bundler
$ sudo apt-get install libxslt-dev libxml2-dev build-essential
$ bundle install --binstubs
```

- Create and migrate DB

```bash
$ cd /vagrant
$ bin/rake db:create db:migrate db:test:prepare # Make sure database.yml has username & password set to 'vagrant'
```



#### Resources

- [Mockups](https://speakerdeck.com/timothyandrew/mockups-of-hosted-wiki-software)
