## CryptiKit

Simple &amp; easy Crypti node deployment and management for Linux / OSX operating systems.

### Prerequisites

One or more freshly installed Ubuntu based cloud servers on Digital Ocean or GetClouder.

### Installation

* Download the latest stable release:
  - https://github.com/karmacoma/cryptikit/releases/latest

* Run the automated install script. Tested on OSX 10.9.3 and Ubuntu 14.04 LTS.

```
./install.sh
```

* To update an existing installation to the latest stable release:

```
./update.sh
```

### Managing Server List

* To list available servers:

```
rake list_servers
```

* To add a server:

```
rake add_servers servers=130.211.63.634
```

* To add multiple servers at the same time:

```
rake add_servers servers=130.211.63.634,130.211.93.171,130.211.63.63
```

* To remove a server:

```
rake remove_servers servers=0 # 1st server
```

* To remove multiple servers at the same time:

```
rake remove_servers servers=0,1,7 # 1st, 2nd and 7th server
```

Which will remove servers 0, 1 and 7 as defined in your config.

### Typical Usage

* Add your public ssh key to each server:

```
rake add_key
```

> NOTE:
> On Digital Ocean, when logging in for the first time you may be prompted to change your password.

> NOTE:
> If you do not have a key, then CryptiKit will prompt you to generate one. At which point CryptiKit will proceed with adding the key to each server.

* Prepare each server for installation of crypti node:

```
rake install_deps
```

* Install crypti node on each server:

```
rake install_nodes
```

> NOTE:
> Crypti node will be automatically started after installation.

* Check loading status of crypti nodes:

```
rake get_loading
```

* Start forging:

```
rake start_forging
```

> NOTE:
> Please wait for blockchain to be fully loaded before executing forging commands.

### Commands

Type ```rake -T``` to get a complete list of commands.

```
rake add_key          # Add your public ssh key
rake add_servers      # Add servers to config
rake get_forging      # Get forging status
rake get_loading      # Get loading status
rake install_deps     # Install dependencies
rake install_nodes    # Install crypti nodes
rake list_servers     # List available servers
rake rebuild_nodes    # Rebuild crypti nodes (using new blockchain only)
rake remove_servers   # Remove servers from config
rake restart_nodes    # Restart crypti nodes
rake start_forging    # Start forging on crypti nodes
rake start_nodes      # Start crypti nodes
rake stop_forging     # Stop forging on crypti nodes
rake stop_nodes       # Stop crypti nodes
rake uninstall_nodes  # Uninstall crypti nodes
```

#### Targeting Individual Servers

By default the tasks will execute on all servers defined in your config.
You can target specific servers with any of the commands like so.

```
rake get_loading servers=0,1,7 # 1st, 2nd and 7th server
```

Which will execute the get_loading task only on servers 0, 1 and 7 as defined in your config.

#### Forging

Forging is controlled using the commands: ```rake start_forging``` and ```rake stop_forging```. When executing these commands, CryptiKit will prompt you for the secret passphrase of each node. Each passphrase is sent over the existing SSH tunnel and then submitted locally to the crypti node using curl.

> NOTE:
> You will need >= 1000 XCR in the specified account to start forging.

### Bugs

I have tested these commands on both Digital Ocean and GetClouder using Ubuntu 14.04 LTS droplets / containers.
Please let me know if you encounter any issues: karmacrypto@gmail.com.

### Changelog

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
* Added add_key task to upload public ssh key to each server
* Added restart_nodes task

2014-09-12

* Initial release

### Todo

* Add "get_balances" task to check balance of each node
* Write test suite, fix bugs

### Donations

Welcome at the following address: 18246983367770087687C.
