# chef-one
Convenient extensions and wrappers to streamline Chef Zero commands.

## Motivations

The command-line chef-client suffers from some annoying limitations, which makes the interface clunky. Among them:

* No simple way to handle Berksfile dependencies. Requires separate Berkshelf commands.
* On a single chef-zero run, easiest way to use Berkshelf is to vendor, but that requires multiple commands to 
initialize and cleanup.
* No support for the ./site-cookbooks, chef-repo application pattern. Chef-zero only recognizes cookbooks in an explicitly
named cookbooks directory.

chef-one acts as a wrapper to chef-zero, handling the above in a single-command interface pattern. Simply point it to a 
cookbook in any directory, anywhere with a valid Berksfile and it runs any valid recipe.

The chef-zero command line tool isn't built to easily handle more complex cookbook structures. Complex scenarios tend to be
handled by Test Kitchen during developement and Chef Server/Managed Chef in production. However there are valid reasons to 
prefer Chef Zero during both. The former requires running a Vagrant virtual machine, which may be unavailable or simply 
outside the system capabilities of light-weight instances (e.g. micro EC2 instances). Chef server may be needlessly complex
overkill for simple deployement schemes.
