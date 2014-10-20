### CryptiKit Changelog

2014-10-20 (1.6.1)

- Fixed network fee calculation:  
  Surplus withdrawals should now consistently leave a minimum of 1000 XCR plus some dust
- Allowing withdrawal / deposit address to be specified from the command line  
  For example:
  ```
  rake withdraw_surplus address=18246983367770087687C
  ```
- Re-factored number handling for better accuracy

2014-10-18 (1.6.0)

- Added withdraw_surplus task

The ```withdraw_surplus``` task withdraws any surplus balance above the minimum 1000 XCR required to start forging, to a designated crypti account.

Instructions for this new task are available here:
- https://github.com/karmacoma/cryptikit/blob/master/README.md#surplus-withdrawals

2014-10-12 (1.5.1)

This release coincides with the release of Crypti Node 0.1.7. It contains some important bug fixes, improvements to the installation process and a general refactoring of the code base.

#### Updates

- Updated crypti node to latest version: 0.1.7
- Updated blockchain download url

#### Bug Fixes

- Fixed targeting of servers when a range is provided
- Fixed checking of remote dependencies when crypti node has not been installed yet
- When running the automated update script:
  - Latest stable release of rvm is installed
  - Gems are updated and old versions removed
  - CrypiKit gemset is recreated if missing

#### Auto-completion

- Moved bash auto-completion script to bin/completer.rb

On existing installations, please run the following command to re-enable bash auto-completion:

```
ruby bin/completer.rb --re-enable
```

2014-09-29 (1.5.0)

- Implemented optional bash auto-completion of tasks
- Added more options for targeting servers:
  - All servers via: rake command servers=all
  - Range of servers via: rake command servers=5..10
  - Selection of servers via: rake command servers=1,3,7 (as before)
  - When no servers are provided. Prompting user for y/n answer to run task on all servers
- Added "install_all" task to install both dependencies & crypti nodes using one command
- Dependency errors are now handled like connection errors and are included in the report summary
- Dependencies are now stated as they are found on local/remote system
- Stopped install.sh script forking a new shell on installation

2014-09-24 (1.4.0)

> NOTE: Config file update required. Please run the ```start_forging``` task on all of your nodes after downloading this release. This is due to an API key that needs to be added to the config, before forging statistics can be successfully retrieved.

#### Bug Fixes

- Resolved issue when installing on servers where nodejs already installed
- Ensuring all existing processes are stopped before starting a node
- Checking crypti node is installed before executing certain tasks
- Removing blockchain.db.zip after decompressing it during tasks

#### Features / Improvements

- Added forging information to "check_nodes" task including:
  - Forged coins by each individual node
  - Last forged block by each individual node
  - Total forged for all selected nodes
- Graceful handling of common ssh connection errors
- Listing 'bad' nodes at end of "check_nodes" report summary
- More consistent, easier to read, colorized log messages

2014-09-22 (v1.3.1)

* Fixed installation issue when installing rvm as root
* Fixed issue with updating of git tree to latest release tag
* Locked ruby installation to version: 2.1.2 (for now)

2014-09-22 (v1.3.0)

* Added detailed report summary to "check_nodes" task
* Decompressing new blockchain.db.zip file after download
* Node "keys" now start at 1 instead of 0 for easier referencing
* Improved handling of empty JSON responses
* Improved error handling of failed API calls

2014-09-19 (v1.2.0)

* Replaced "get_loading", "get_forging" and "get_balances" with single task "check_nodes"
* Implemented dependency checks on local/remote machines before executing tasks
* Removing orphan accounts when saving server list

2014-09-18 (v1.1.3)

* Added "get_balances" task
* Prettified output of "get_loading", "get_forging" and "get_balances" tasks

2014-09-17 (v1.1.2)

* Added "log_into" task for logging into servers directly
* Fixed "rebuild_nodes" task: old blockchain is now deleted properly
* Fixed automated update script: now checks out the latest release tag

2014-09-16 (v1.1.1)

* Gracefully handling required password change on Digital Ocean droplets
* Reindexing server list after deleting servers to maintain sane key order

2014-09-16 (v1.1.0)

* Added "list_servers" task
* Added "add_servers" / "remove_servers" tasks
* Added automated update script to get the latest CryptiKit release

2014-09-15 (v1.0.0)

* Added "rebuild_nodes" task to rebuild nodes using new blockchain only
* Added "start_forging" / "stop_forging" tasks to enable and disable forging
* Added "get_forging" task to verify forging status of each node

2014-09-13

* Added automated install script to ease installation of CryptiKit
* Added ability to target individual servers with each command
* Added "add_key" task to upload public ssh key to each server
* Added "restart_nodes" task

2014-09-12

* Initial release
