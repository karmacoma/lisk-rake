## CryptiKit

Simple &amp; easy Crypti node deployment and management for Linux / OSX operating systems.

### Prerequisites

One or more Ubuntu based droplets on Digital Ocean / GetClouder with your public SSH keys added.

### Installation


* Install homebrew (OSX only).

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

* Install rvm.
```
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```

Make sure rvm is loaded, or just open a new terminal. See: https://rvm.io/.

* Clone repo.
```
git clone https://github.com/karmacoma/cryptikit.git
```

* Install gems.
```
cd cryptikit;bundle install
```

### Configuration

Open config.yml and add server IP addresses like so:

```
servers:
  0: '130.211.63.634' # Server 1
  1: '130.211.93.171' # Server 2
  2: '130.211.63.63'  # Server 3
```

1. Preparing servers:

```
rake install_deps
```

2. Installing crypti on each node:

```
rake install_nodes
```

3. Starting nodes:

```
rake start_nodes
```

4. Check loading status:

```
rake get_loading
```

### Available commands

```
rake get_loading      # Get loading status
rake install_deps     # Install dependencies
rake install_nodes    # Install crypti nodes
rake start_nodes      # Start crypti nodes
rake stop_nodes       # Stop crypti nodes
rake uninstall_nodes  # Uninstall crypti nodes
```

### Compatibility

I have tested these tasks on Digital Ocean and GetClouder using Ubuntu 14.04 droplets / containers.
Please let me know if you encounter any issues.

### TODO List

* Add add_keys task to upload ssh keys to each server
* Add setup_forging task to enable forging on each server
