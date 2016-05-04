# chef-one
Convenient extensions and wrappers to streamline Chef Zero commands.

### Motivations

The command-line chef-client suffers from some annoying limitations, which makes the interface clunky. Among them:

* No simple way to handle Berksfile dependencies. Requires separate Berkshelf commands.
* On a single chef-zero run, easiest way to use Berkshelf is to vendor, but that requires multiple commands to 
initialize and cleanup.
* No support for the ./site-cookbooks, chef-repo application pattern. Chef-zero only recognizes cookbooks in an explicitly
named cookbooks directory.
* No support for standalone cookbooks. Leads to file-system boilerplate. Requires a cookbooks/ parent directory following the chef-repo pattern.

chef-one acts as a wrapper to chef-client, handling the above in a single-command interface pattern. Simply point it to a 
cookbook in any directory, anywhere with a valid Berksfile and it runs any valid recipe.

The chef-zero command line tool isn't built to easily handle more complex cookbook structures. Complex scenarios tend to be
handled by Test Kitchen during developement and Chef Server/Managed Chef in production. However there are valid reasons to 
prefer Chef Zero during both. The former requires running a Vagrant virtual machine, which may be unavailable or simply 
outside the system capabilities of light-weight instances (e.g. micro EC2 instances). Chef server may be needlessly complex
overkill for simple deployement schemes.

### Quickstart

chef-one is a light-weight shell script wrapper around the chef-client. There are no binaries or libraries that need to be
installed at the system level. Simply clone the repo in anywhere in the file system, point your shell at the bin, and invoke the command. Assuming you're using bash shell:

```
bash$ git clone git@github.com:Mister-Meeseeks/chef-one.git ~
bash$ echo "export PATH=$PATH:~/chef-one/bin/" >> ~/.bashrc
bash$ bash   # Reset bash session with new PATH
bash$ chef-one --help
```

### Usage

For standard chef-repo format:

` bash$ chef-one [my_chef_repo]/cookbooks/[my_coobook]  [my_recipe]

For site-cookbooks chef-app format:

` bash$ chef-one [my_chef_repo]/site-cookbooks/[my_cookbook]  [my_recipe]

For standalone cookbooks not in repo directory structure:

` bash$ chef-one [my_cookbook]  [my_recipe]

### Dependencies

* chef-client (version >= 12.0)
* berkshelf (version >= 4.0)
* bash (can be invoked from any shell, but bash must be installed)
