# Set Up

Required Files:

* .rvmrc
* Gemfile
* Gemfile.lock
* config/database.yml
* .git/config
* config/unicorn.rb


### Setting up .git/config


Your .git/config should know about the remotes you will be using to deploy to the server (usually just origin) as it will pull information about the remote from your local config file


### Setting up RVM

On your ruby servers you should create a .rvmrc in the home directory of the user running unicorn.

```bash
rvm_install_on_use_flag=1

rvm_gemset_create_on_use_flag=1

rvm_trust_rvmrcs_flag=1
```


### Required gems

* rake
* bundler
* unicorn

ors deploy commands assume you are using unicorn for your servers.



# Usage

run `ors help` for a list of commands to use.


### Brief Examples

Deploying to the staging website

```bash
bundle exec ors deploy to staging
```

Deploying a feature branch to the production website

```bash
bundle exec ors deploy origin/feature_branch
```

Deploying a feature branch to the staging website

```bash
bundle exec ors deploy origin/feature_branch to staging
```

### Notes
* By default the environment is assumed to be production and the branch you are deploying is assumed to be origin/#{environment}.
* You can override settings by implementing a config/deploy.yml file in your repo.


