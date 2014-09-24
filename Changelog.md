### CryptiKit Changelog

2014-09-24 (1.4.0)

> NOTE: Config file update required. Please run the ```start_forging``` task on all of your nodes after downloading this release. This is due to an API key that needs to be added to the config, before forging statistics can be successfully retrieved.

Bug Fixes

- Resolved issue when installing on servers where nodejs already installed
- Ensuring all existing processes are stopped before starting a node
- Checking crypti node is installed before executing certain tasks
- Removing blockchain.db.zip after decompressing it during tasks

Features / Improvements

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
