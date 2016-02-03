# Lisk Rake

Lisk Rake is a node deployment and management tool for [Lisk](https://lisk.io/). It provides a command-line interface from which delegates can manage nodes remotely from a local machine, allowing delegates to seamlessly install, upgrade and monitor them using just a few simple commands.

## Installation

  [https://github.com/LiskHQ/lisk-rake/releases/latest](https://github.com/LiskHQ/lisk-rake/releases/latest)

* Run the automated install script. Tested on Ubuntu 14.04 (LTS) and OS X El Capitan.

```
cd lisk-rake
bash install.sh
```

> NOTE:
> This will install homebrew (on OS X), ruby (rvm) plus a few application dependencies.

***

* To update an existing installation to the latest stable release:

```
cd lisk-rake
bash update.sh
```

> NOTES:
> 1. The existing configuration file will be copied to: config.bak. LiskRake will then copy any pre-configured servers and accounts over to the newly downloaded config.yml file.
> 2. If you encounter any issues when updating from an older version of LiskRake. Please try running ```rvm implode``` followed by entering ```yes```. Then execute ```. install.sh``` to perform a fresh installation (your LiskRake configuration will be preserved).

***

## Managing Servers

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

***

## Authentication

Connections to each server require public key ssh authentication. To add your public key to each server, simply run the following command:

```
rake add_key
```

> NOTES:
>
> 1. You can skip this step, if you have already added your public ssh key when deploying your server.
> 2. If you do not have a key yet, LiskRake will prompt you to generate one.
> 3. On Digital Ocean, when logging in for the first time you may be prompted to change your password.

***

## Installing Nodes

To install the required dependencies plus the latest version of lisk on all server(s), simply run the following commands:

```
rake install_deps
rake install_nodes
```

You can also install both of the above using the following command:

```
rake install_all
```

***

## Reinstalling Nodes

To reinstall the latest version of lisk on all servers whilst keeping the existing blockchain, simply run the following command:

```
rake reinstall_nodes
```

***

## Forging

Forging is controlled using the commands: ```rake start_forging``` and ```rake stop_forging```. When executing these commands, LiskRake will prompt you for the secret passphrase of each node. Each passphrase is sent over the existing SSH tunnel and then submitted locally to the lisk node using curl.

> NOTE:
> You will need to register as a delegate before you can start forging. To earn LISK, your delegate will need to receive enough votes to be ranked within the top 101 delegates.

To start forging, simply run the following command:

```
rake start_forging
```

When prompted, enter your primary passphrase:

```
Please enter your primary passphrase: _____
```

Once forging has been successfully started, you will be provided with the option to add the passphrase to the remote config.

```
INFO Enabling forging...
INFO => Enabled.
INFO Adding account...
INFO => Added: 4956977736153893179L.
INFO Adding passphrase to remote config...

Add passphrase to remote config? _____
```

> NOTE:
> Adding your passphrases to the config file is less secure. Only do so if you wish to avoid having to start forging again after a node has been restarted.

### Multiple Delegates

After each attempt, LiskRake will ask if you want to enable another delegate until you specify otherwise. Thus allowing you to start forging for multiple delegates using one instance of the  ```rake start_forging``` command.

> NOTE:
> Forging can be stopped for multiple delegates in the same manner using the ```rake stop_forging``` command.

***

## Checking Nodes

To check the status of your nodes, simply run the following command:

```
rake check_nodes
```

The ```check_nodes``` task performs a full inspection of each node. Including: CPU/Memory usage, node uptime, node version, blockchain loading/syncing status, plus each delegate's forging activity and associated account balance(s).

```
Checking nodes...
================================================================================
Node[1]: 111.11.11.111 With 2 Delegate(s)
================================================================================
Usage:             CPU: 1.1% | Memory: 18.8%
Uptime:            0-10:57:0.586
Version:           0.2.0
Loaded:            true
Syncing:           false
Height:            162573
--------------------------------------------------------------------------------
Delegate:          (1) Olivier [Active] 14636030356238523094L
Productivity:      71.59%
Rank:              15
Forging:           true
Last Forged:       0.0 @ 1027287 -> 2015-08-15 19:03:40 +0100
Forged:            320.67081153 0.0 (*)
Balance:           174644.91081588 0.0 (*)
Unconfirmed:       174644.91081588 0.0 (*)
--------------------------------------------------------------------------------
Delegate:          (2) Karmacoma [Standby] 4956977736153893179L
Productivity:      0.0%
Rank:              120
Forging:           true
Balance:           13.00000001 0.0 (*)
Unconfirmed:       13.00000001 0.0 (*)
```

After running the ```check_nodes``` task. LiskRake produces a detailed summary containing: the total nodes checked, report times, total forged, total balances, lowest / highest balances, followed by a breakdown of any nodes/delegates which are either currently loading, syncing, on standby, not forging or using an outdated version of lisk.

Please see the below example:

```
================================================================================
Report Summary
================================================================================
Nodes Checked:     1 / 1 Configured
Generated:         2015-04-09 01:17:06 +0100
Last Generated:    2015-04-09 01:17:06 +0100
Total Forged:      320.67081153 320.67081153 (+)
Total Balance:     174657.91081589 174657.91081589 (+)
Total Unconfirmed: 174657.91081589 174657.91081589 (+)
Lowest Balance:    13.00000001 -> Node[1](Karmacoma)
Highest Balance:   174644.91081588 -> Node[1](Olivier)
--------------------------------------------------------------------------------
* 1 / 2 delegates are on standby.
> Affected Delegates: Node[1](Karmacoma)
--------------------------------------------------------------------------------
```

The report summary warns you when there are potential issues with one your nodes or delegates. Below are some further examples of what might expect to see.

### Loading

When one or nodes are loading.

```
* 2 / 4 nodes are not loaded.
> Affected Nodes: 1,4
--------------------------------------------------------------------------------
```

### Syncing

When one or nodes are being synchronised.

```
* 2 / 4 nodes are being synchronised.
> Affected Nodes: 1,4
--------------------------------------------------------------------------------
```

### On Standby

When one or delegates are on standby awaiting further votes.

```
--------------------------------------------------------------------------------
* 1 / 2 delegates are on standby.
> Affected Delegates: Node[1](Karmacoma)
--------------------------------------------------------------------------------
```

### Not Forging

When one or nodes are being synchronised.

```
* 2 / 4 delegates are not forging.
> Affected Delegates: Node[1](Olivier),Node[1](Karmacoma)
--------------------------------------------------------------------------------
```

### Outdated

When one or nodes are using an outdated version of lisk.

```
* 2 / 4 nodes are outdated.
> Affected Nodes: 1,4

Version: 0.5.4 is now available.

Please run the folowing command to upgrade them:
$ rake reinstall_nodes servers=1,4
--------------------------------------------------------------------------------
```

### Errors

Any connection / authentication / dependency errors encountered while running the ```check_nodes``` task, are automatically recorded by LiskRake and subsequently reported back to you at the end of the Report Summary.

```
--------------------------------------------------------------------------------
* 3 nodes encountered errors and were not checked.

Error Messages:
* Node[13] => Connection closed by remote host.
* Node[14] => Connection refused.
* Node[15] => Authentication failed.
--------------------------------------------------------------------------------
```

### Balance Changes

Applies to all balances generated by the check_nodes task: Account and Forged balances. Making it much easier to visually track when one of your nodes has forged some coins or their balances have changed in some other way.

Upon first invocation you will see the following highlighted in blue, which indicates this is the first time you are running the report hence there are no changes:

<pre><code>Balance:           1344.4791879 0.0 (&#42;)</code></pre>

When a balance has not changed you will see the following highlighted in yellow:

<pre><code>Balance:           1344.4791879 0.0 (&#61;)</code></pre>

When a balance has increased by 100 you will see the following output highlighted in green:

<pre><code>Balance:           1444.4791879 100.0 (&#43;)</code></pre>

When a balance has decreased by 100 you will see the following output highlighted in red:

<pre><code>Balance:           1244.4791879 100.0 (&#45;)</code></pre>

***

## Commands

Type ```rake -T``` to get a complete list of commands.

```
rake add_key         # Add your public ssh key
rake add_servers     # Add servers to config
rake check_nodes     # Check status of lisk nodes
rake clean_logs      # Clean logs on each server
rake download_logs   # Download logs from each server
rake install_all     # Install dependencies and lisk nodes
rake install_deps    # Install dependencies
rake install_nodes   # Install lisk nodes
rake list_servers    # List configured servers
rake log_into        # Log into servers directly
rake rebuild_nodes   # Rebuild lisk nodes (using new blockchain only)
rake reinstall_nodes # Reinstall lisk nodes (keeping blockchain and config intact)
rake remove_servers  # Remove servers from config
rake restart_nodes   # Restart lisk nodes
rake start_forging   # Start forging on lisk nodes
rake start_nodes     # Start lisk nodes
rake stop_forging    # Stop forging on lisk nodes
rake stop_nodes      # Stop lisk nodes
rake uninstall_nodes # Uninstall lisk nodes
rake withdraw_funds  # Withdraw funds from lisk nodes
```

### Bash Auto-completion

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

***

## Targeting Servers

* When no servers are specified, LiskRake will prompt you to run the task on all servers.
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

***

## Withdrawals

The ```withdraw_funds``` task allows you to withdraw a specific amount from one of the lisk accounts associated with a given node, to a designated recipient lisk account.

The required steps are as follows:

1. Specify a recipient addres
2. Choose an account to withdraw from
3. Enter a withdrawal amount
4. Enter your passphrase(s)

### Recipient Address

Upon executing the ```withdraw_funds``` task. LiskRake will prompt you to enter the recipient address where you would like the funds to go to.

For example:

```
rake withdraw_funds servers=1..3 # Servers 1 to 3

Withdrawing funds...
Please enter your recipient lisk address: _____
```

When given an invalid address. LiskRake will prompt you to try again:

```
rake withdraw_funds servers=1..3 # Servers 1 to 3

Withdrawing funds...
Please enter your recipient lisk address: _____
Invalid lisk address. Please try again...
```

The recipient address can also be specified from the command line:

```
rake withdraw_funds servers=1..3 recipient=4956977736153893179L # Servers 1 to 3
```

### Withdrawal Account

As one or more accounts can be associated with any given node. When making a withdrawal, LiskRake will present you with a list of accounts to choose from for the current node, like so:

```
--------------------------------------------------------------------------------
Available accounts on: Node[1]
--------------------------------------------------------------------------------
1: 14636030356238523094L
2: 707434884386221427L

Please choose an account [1-2]: _____
--------------------------------------------------------------------------------
```

### Withdrawal Amount

Once a valid recipient address has been specified. LiskRake will present the current balance and maximum possible withdrawal, then prompt you to enter the desired amount to withdraw from the chosen account.

```
INFO Checking account balance...
INFO => Current balance: 184704.90731913 LISK.
INFO => Maximum withdrawal: 183785.97743197 LISK.

Enter withdrawal amount: _____
```

> NOTE: Maximum withdrawals are the total balance less the current network transaction fee.

### Passphrases

Before sending any funds, LiskRake will prompt you to enter your primary passphrase. LiskRake supports secondary passphrases, so if your account has one, LiskRake will prompt you for that as well.

### Successful Transactions

For each successful transaction, LiskRake will output the fee, transaction id and total amount sent.

```
INFO Withdrawing 1.0 LISK...
INFO From: 14636030356238523094L to: 4956977736153893179L...
INFO ~> Fee: 0.005
INFO ~> Transaction id: 2052732297350569719
INFO ~> Total withdrawn: 1.0
```

### Error Handling

If any errors are encountered during a transaction. For example an invalid passphrase, LiskRake will handle the error and move onto the next selected server.

```
INFO Withdrawing 1.0 LISK...
INFO From: 14636030356238523094L to: 4956977736153893179L...
ERROR => Transaction failed.
ERROR => Error: Provide secret key.
```

***

## Authors

- Olivier Beddows <olivier@lisk.io>

***

## License

[GNU GENERAL PUBLIC LICENSE (Version 3)](LICENSE)
