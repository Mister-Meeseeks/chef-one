# chef-one
Convenient extensions and wrappers to streamline Chef Zero commands.

### Motivation

The command-line chef-client suffers from some annoying limitations, which makes the interface clunky. Among them:

* No simple way to handle Berksfile dependencies. Requires parrallel invocation of Berkshelf commands and setup.
* Berkshelf install doesn't work with chef-client. On a single chef-zero run, easiest way to use Berkshelf is to manually vendor. But that requires the user to manually setup and tear-down on each run in a tedious and error-prone way.  
* No support for the ./site-cookbooks, chef-repo application pattern. Chef-zero only recognizes cookbooks in an explicitly
named cookbooks directory.
* No support for standalone cookbooks. Leads to file-system boilerplate. Requires a cookbooks/ parent directory following the chef-repo pattern.
* chef-client must be called with chef-repo as the working directory. If working from another directory, requires tedious cd [repo]/cd - bookends around each call.

chef-one acts as a wrapper to chef-client, handling the above in a single-command interface pattern. Simply point it to a 
cookbook in any directory, anywhere with a valid Berksfile and it runs any valid recipe.

The chef-zero command line tool isn't built to easily handle more complex cookbook structures. Complex scenarios tend to be
handled by Test Kitchen during developement and Chef Server/Managed Chef in production. However there are valid reasons to 
prefer Chef Zero during both. The former requires running a Vagrant virtual machine, which may be unavailable or simply 
outside the system capabilities of light-weight instances (e.g. micro EC2 instances). Chef server may be needlessly complex
overkill for simple deployement schemes.

### Quickstart

chef-one is a light-weight shell script wrapper around the chef-client. There are no binaries or libraries that need to be
installed at the system level. Simply clone the repo anywhere in your file system, make the shell aware of the bin script, and invoke the command. Aliasing the bin, exporting the repo's bin dir, or sym-linking the bin to an existing PATH directory are all working options. Assuming you're using bash shell and decide to export:

```
bash$ git clone https://github.com/Mister-Meeseeks/chef-one.git ~
bash$ export PATH=$PATH:~/chef-one/bin/
bash$ chef-one --help
```

### Install

To permanetely install in a system PATH directory, clone the repo to some permanent location. Then run the install.sh script, to create an executable (by default in /usr/local/bin/).

```
bash$ sudo git clone https://github.com/Mister-Meeseeks/chef-one.git /usr/local/src/
bash$ sudo /usr/local/src/install.sh
```

To install in specific directory instead

```
bash$ sudo /usr/local/src/install.sh [install directory]
```

Make sure to clone the install repo in a permanent location (like /usr/local/src) and don't remove. The installed binary is a sym-link to the repo, so removing the repo will break the command.

### Usage

For standard chef-repo format w/ default recipe:

    bash$ chef-one [my_chef_repo]/cookbooks/[my_coobook]

For chef-repo with specified recipe:
    
    bash$ chef-one [my_chef_repo]/cookbooks/[my_coobook]  [my_recipe]

For site-cookbooks chef-app format:

    bash$ chef-one [my_chef_repo]/site-cookbooks/[my_cookbook]  [my_recipe]

For standalone cookbooks not in repo directory structure w/ default recipe:

    bash$ chef-one [my_cookbook]

### Dependencies

* chef-client (version >= 12.0)
* berkshelf (version >= 4.0)
* bash (can be invoked from any shell, but bash must be installed)

### Internals

chef-one acts as a wrapper, tracing the following work-flow on each call:

1. Create a chef-repo sandbox at $PWD/.chef_one_sandbox/
2. Use Berkshelf to version the targeted cookbook and all dependencies in sandbox/cookbooks/
3. Step into the sandbox and invoke the chef-zero client on the target recipe.
4. After success or failure cleanup the sandbox directory.
