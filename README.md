## CryptiKit

Simple &amp; easy Crypti node deployment and management for Linux / OSX operating systems.

### Prerequisites

One or more freshly created Ubuntu based cloud servers on Digital Ocean or GetClouder.

### Installation

* Download the latest stable release:
  - https://github.com/karmacoma/cryptikit/releases/latest

* Run the automated install script. Tested on OSX 10.9.3 and Ubuntu 14.04 LTS.

```
./install.sh
```

> NOTE:
> This will install homebrew (on OSX), ruby (rvm) plus a few application dependencies.

* To update an existing installation to the latest stable release:

```
./update.sh
```

> NOTE:
> The existing configuration file will be copied to: config.bak.

### Managing Server List

* To list configured servers:

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
rake remove_servers servers=1 # 1st server
```

* To remove multiple servers at the same time:

```
rake remove_servers servers=1,2,7 # 1st, 2nd and 7th server
```

Which will remove servers 1, 2 and 7 as defined in your config.

### Typical Usage

* Add your public ssh key to each server:

```
rake add_key
```

> NOTE:
> On Digital Ocean, when logging in for the first time you may be prompted to change your password.

> NOTE:
> If you do not have a key, then CryptiKit will prompt you to generate one. At which point CryptiKit will proceed with adding the key to each server.

* Install application dependencies on each server:

```
rake install_deps
```

* Install crypti node on each server:

```
rake install_nodes
```

> NOTE:
> Crypti node will be automatically started after installation.

* Start forging:

```
rake start_forging
```

> NOTE:
> You will be prompted to enter an individual secret passphrase for each crypti node.

* Check status of each crypti node:

```
rake check_nodes
```

This task outputs the blockchain/forging status and account balance(s) of each crypti node.

```
Checking nodes...
INFO Node[1]: 111.11.11.111 (9473799116182005461C)
INFO Getting loading status...
INFO => Done.
--------------------------------------------------------------------------------
Node[1]: 111.11.11.111 (9473799116182005461C)
--------------------------------------------------------------------------------
Loaded:      true
Height:      31242
Blocks:      28594
Forging:     true
Balance:     1002.92826902
Unconfirmed: 1002.92826902
Effective:   1002.92826902
```

When running the ```check_nodes``` task. CryptiKit now produces a detailed summary containing the total nodes checked, total balances, lowest / highest balances, followed by a breakdown of any nodes which are either not loaded properly, or not currently forging. Please see the below example:

```
================================================================================
Report Summary
================================================================================
Nodes Checked:     24 / 24 Configured
Total Balance:     26915.88691914
Total Unconfirmed: 26915.88691914
Total Effective:   26915.88691914
Lowest Balance:    1000.00168904 -> Node[15]
Highest Balance:   2421.74114445 -> Node[9]
--------------------------------------------------------------------------------
* 1 / 24 nodes are not loaded properly.
> Affected Nodes: 4
--------------------------------------------------------------------------------
* 2 / 24 nodes are not currently forging.
> Affected Nodes: 1,4
--------------------------------------------------------------------------------
```

### Commands

Type ```rake -T``` to get a complete list of commands.

```
rake add_key          # Add your public ssh key
rake add_servers      # Add servers to config
rake check_nodes      # Check status of crypti nodes
rake install_deps     # Install dependencies
rake install_nodes    # Install crypti nodes
rake list_servers     # List configured servers
rake log_into         # Log into servers directly
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
rake check_nodes servers=1,2,7 # 1st, 2nd and 7th server
```

Which will execute the check_nodes task only on servers 1, 2 and 7 as defined in your config.

#### Forging

Forging is controlled using the commands: ```rake start_forging``` and ```rake stop_forging```. When executing these commands, CryptiKit will prompt you for the secret passphrase of each node. Each passphrase is sent over the existing SSH tunnel and then submitted locally to the crypti node using curl.

> NOTE:
> You will need >= 1000 XCR in the specified account to start forging.

### Bugs

I have tested these commands on both Digital Ocean and GetClouder using Ubuntu 14.04 LTS droplets / containers. Please let me know if you encounter any issues: karmacrypto@gmail.com.

### Changelog

See: https://github.com/karmacoma/cryptikit/blob/master/Changelog.md

### Todo

* Write test suite, fix bugs

### Donations

Welcome at the following address: 18246983367770087687C.
