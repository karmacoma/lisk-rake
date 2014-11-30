## CryptiKit

Simple &amp; easy Crypti node deployment and management for Linux / OSX operating systems.

### Supported Hosts

#### DigitalOcean

Supported operating systems:
- CentOS (7.0 x64)
- Debian (7.0 x64)
- Fedora (20 x64)
- Ubuntu (14.04 x64)

> Link: https://www.digitalocean.com/?refcode=c637b271d39f

#### GetClouder

Supported operating systems:
- CentOS (7.0 x64)
- Debian (7.0 x64)
- Ubuntu (14.04 x64)

> Link: https://www.getclouder.com/

#### Vultr

Supported operating systems:
- CentOS (7.0 x64)
- Debian (7.0 x64)
- Ubuntu (14.04 x64)

> Link: http://www.vultr.com/?ref=6814545

#### Wable

Supported operating systems:
- debian-7.0-x86_64
- fedora-20-x86_64
- ubuntu-13.10-x86_64
- ubuntu-14.04-x86_64-minimal

> Link: http://www.wable.com/

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

#### Updating CryptiKit

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

Once forging has been started, you will be provided with the option to add the passphrase to the remote config.

```
INFO Adding account...
INFO => Added: 9473799116182005461C.
INFO Adding passphrase to remote config...
Add passphrase to remote config? yes
INFO => Done.
```

> NOTE:
> Adding your passphrases to the config file is less secure. Only do so if you wish to avoid having to start forging again after a node has been restarted.

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
Syncing:           false
Forging:           true
Last Forged:       Block -> 12886241379965779851 Amount -> 0.0
Forged:            2.92869137
Balance:           1002.92869137
Unconfirmed:       1002.92869137
Effective:         1002.92869137
```

When running the ```check_nodes``` task. CryptiKit produces a detailed summary containing the total nodes checked, total forged, total balances, lowest / highest balances, followed by a breakdown of any nodes which are either currently loading, syncing or not forging. Please see the below example:

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
* 1 / 24 nodes are not loaded.
> Affected Nodes: 1
--------------------------------------------------------------------------------
* 1 / 24 nodes are being synchronised.
> Affected Nodes: 4
--------------------------------------------------------------------------------
* 2 / 24 nodes are not forging.
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

#### Mining Info

Mining information can be optionally disabled either permanently through CryptiKit's configuration file or at runtime from the command line. When disabled CryptiKit will only check whether a node has forging enabled.

* To disable mining info permanently via the configuration file. Open config.yml and change ```mining_info: enabled``` to: ```mining_info: disabled```.
* To disable mining info optionally at runtime use: ```rake check_nodes mining_info=disabled```.

> NOTE:
> Mining information will be automatically disabled unless specfically enabled through CryptiKit's configuration file or at runtime from the command line.

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
rake withdraw_surplus # Withdraw surplus coinage from crypti nodes
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
```

```
Choosing servers...
No servers chosen. Run this task on all servers? y
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

#### Surplus Withdrawals

The ```withdraw_surplus``` task withdraws any surplus balance above the minimum 1000 XCR required to start forging, to a designated crypti account.

For example the command:

```
rake withdraw_surplus servers=1..3 # Servers 1 to 3
```

Will check nodes 1, 2 and 3 for surplus balances and withdraw them to a designated deposit address.

##### Deposit Address

Upon executing the ```withdraw_surplus``` task. CryptiKit will first prompt you to enter the deposit address where you want to the funds to be sent to. If an invalid address is provided you will be prompted by CryptiKit to try again.

For example:

```
Withdrawing surplus coinage...
Please enter your crypti address: 18246983367770087687C
```

When given an invalid address. CryptiKit will prompt you to try again:

```
Withdrawing surplus coinage...
Please enter your crypti address: --------------*
Invalid crypti address. Please try again...
```

The deposit address can also be specified from the command line:

```
rake withdraw_surplus servers=1..3 address=18246983367770087687C # Servers 1 to 3
```

##### Surplus Balances

The ```withdraw_surplus``` task will only process nodes with a surplus balance above the minimum 1000 XCR required to start forging.

> NOTE: Minimum withdrawal is 0.01 XCR. Anything less than that will be ignored.

For example: When a node has a balance greater than 1000 XCR:

```
INFO Checking for surplus coinage...
INFO => Available: 4.99396644 crypti.
```

For example: When a node has a balance less than or equal to 1000 XCR:

```
INFO Checking for surplus coinage...
WARN => None available.
```

##### Passphrases

Before sending any funds, CryptiKit will prompt you to enter your primary passphrase. If a secondary passphrase is also assigned to an account, CryptiKit will prompt you for that as well.

For example: An account with two passphrases:

```
INFO Checking for surplus coinage...
INFO => Available: 4.99396644 crypti.
Node[2]: 111.11.11.111 (10727915785791958732C): Please enter your primary passphrase: ********
Node[2]: 111.11.11.111 (10727915785791958732C): Please enter your secondary passphrase: ********
```

##### Successful Transactions

For each successful transaction, CryptiKit will output the fee, transaction id and total amount sent.

```
INFO Sending 4.99396644 crypti to: 18246983367770087687C...
INFO ~> Fee: 0.00210831
INFO ~> Transaction id: 13428947504026228865
INFO ~> Total sent: 4.99607475
```

##### Error Handling

If any errors are encountered during a transaction. For example an invalid passphrase, CryptiKit will handle the error and move onto the next selected server.

```
INFO Sending 4.99396644 crypti to: 18246983367770087687C...
ERROR => Transaction failed.
ERROR => Error: Provide secretPhrase.
```

### Bugs

I have tested these commands on: Digital Ocean, GetClouder, Vultr and Wable using various Debian/Ubuntu based containers. Please let me know if you encounter any issues: karmacrypto@gmail.com.

### Changelog

See: https://github.com/karmacoma/cryptikit/blob/master/Changelog.md

### Todo

* Write test suite, fix bugs

### Donations

Welcome at the following address: 18246983367770087687C.
