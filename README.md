## CryptiKit

Simple &amp; easy Crypti node deployment and management for Linux / OSX operating systems.

### Prerequisites

One or more freshly created Ubuntu based cloud servers on Digital Ocean or GetClouder.

### Installation

* Download the latest stable release:
  - https://github.com/karmacoma/cryptikit/releases/latest

* Run the automated install script. Tested on OSX 10.9.3 and Ubuntu 14.04 LTS.

```
cd cryptikit
. install.sh
```

> NOTE:
> This will install homebrew (on OSX), ruby (rvm) plus a few application dependencies.

* To update an existing installation to the latest stable release:

```
cd cryptikit
. update.sh
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

> NOTES:
>
> 1. You can skip this step, if you have already added your public ssh key to the server via your provider's control panel, or at the time of creation.
> 2. If you do not have a key, then CryptiKit will prompt you to generate one. At which point CryptiKit will proceed with adding the key to each server.
> 3. On Digital Ocean, when logging in for the first time you may be prompted to change your password.

* Install dependencies and crypti node on each server:

```
rake install_all
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
================================================================================
Node[1]: 111.11.11.111 (9473799116182005461C)
================================================================================
Loaded:            true
Height:            33950
Blocks:            33829
Forging:           true
Last Forged:       Block -> 12886241379965779851 Amount -> 0.0
Forged:            2.92869137
Balance:           1002.92869137
Unconfirmed:       1002.92869137
Effective:         1002.92869137
```

When running the ```check_nodes``` task. CryptiKit produces a detailed summary containing the total nodes checked, total forged, total balances, lowest / highest balances, followed by a breakdown of any nodes which are either not loaded properly, or not currently forging. Please see the below example:

```
================================================================================
Report Summary
================================================================================
Nodes Checked:     24 / 24 Configured
Total Forged:      1915.88691914
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

Any connection / authentication / dependency errors encountered while running the ```check_nodes``` task, are automatically recorded by CryptiKit and subsequently reported back to you at the end of the Report Summary.

```
--------------------------------------------------------------------------------
* 3 nodes encountered errors and were not checked.

Error Messages:
* Node[13] => Connection closed by remote host.
* Node[14] => Connection refused.
* Node[15] => Authentication failed.
--------------------------------------------------------------------------------
```

### Commands

Type ```rake -T``` to get a complete list of commands.

```
rake add_key          # Add your public ssh key
rake add_servers      # Add servers to config
rake check_nodes      # Check status of crypti nodes
rake install_all      # Install dependencies and crypti nodes
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

#### Bash Auto-completion

Bash auto-completion of commands is enabled on new installations, should you elect to do so.
Existing installations can be enabled via the following command:

```
ruby bin/completer.rb --enable
```

When enabled this gives much quicker access to commands via the tab key. For example:

```
rake che<tab> -> will expand to rake check_nodes
rake lis<tab> -> will expand to rake list_nodes
rake reb<tab> -> will expand to rake rebuild_nodes
```

#### Targeting Servers

* When no servers are specified, CryptiKit will prompt you to run the task on all servers.
Answering y(es) will run the command on all servers. Answering n(o) will exit the current task.

```
rake check_nodes

Choosing servers...
No servers chosen. Do you want to run this task on all servers? y
=> Accepting all servers.
```

* To run a command on a selection of servers:

```
rake check_nodes servers=1,2,7 # 1st, 2nd and 7th server
```

* To run a command on a range of servers:

```
rake check_nodes servers=1..7 # All servers from 1st to 7th
```

* To run a command on all servers without being prompted:

```
rake check_nodes servers=all
```

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
