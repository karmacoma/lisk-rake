## CryptiKit

Simple &amp; easy Crypti node deployment and management for Linux / OSX operating systems.

### Prerequisites

One or more freshly installed Ubuntu based cloud servers on Digital Ocean or GetClouder.

### Installation

* Clone repo.

```
git clone https://github.com/karmacoma/cryptikit.git
```

* Run the automated install script. Tested on OSX 10.9.3 and Ubuntu 14.04 LTS.

```
cd cryptikit
./install.sh
```

### Configuration

Open config.yml and add server IP addresses like so:

```
servers:
  0: '130.211.63.634' # Server 1
  1: '130.211.93.171' # Server 2
  2: '130.211.63.63'  # Server 3
```

### Usage

* Add your public ssh key to each server:

```
rake add_key
```

> NOTE:
> If you do not have a key, then CryptiKit will prompt you to generate one.
> At which point CryptiKit will proceed with adding the key to each server.

* Prepare each server for installation of crypti node:

```
rake install_deps
```

* Install crypti node on each server:

```
rake install_nodes
```

* Start crypti nodes:

```
rake start_nodes
```

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
rake get_forging      # Get forging status
rake get_loading      # Get loading status
rake install_deps     # Install dependencies
rake install_nodes    # Install crypti nodes
rake rebuild_nodes    # Rebuild crypti nodes (using new blockchain only)
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
rake get_loading servers=0,1,7
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

2014-09-15

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

* Add "add_server / remove_server" tasks for easily managing server list
* Add automated update script to get the latest CryptiKit release
* Disallow forging tasks until blockchain is fully loaded

### Donations

Welcome at the following address: 18246983367770087687C.
