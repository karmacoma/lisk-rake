## CryptiKit

Simple &amp; easy Crypti node deployment and management for Linux / OSX operating systems.

### Prerequisites

One or more freshly installed Ubuntu based cloud servers on Digital Ocean or GetClouder.

### Installation

* Clone repo.

```
git clone https://github.com/karmacoma/cryptikit.git
```

* Run automated install script. Tested on OSX 10.9.3 and Ubuntu 14.04 LTS.

```
cd cryptikit;sh install.sh
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

* Prepare servers for installation of crypti node:

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

### Commands

```
rake add_key          # Add your public ssh key
rake get_loading      # Get loading status
rake install_deps     # Install dependencies
rake install_nodes    # Install crypti nodes
rake start_nodes      # Start crypti nodes
rake stop_nodes       # Stop crypti nodes
rake uninstall_nodes  # Uninstall crypti nodes
```

### Bugs

I have tested these tasks on both Digital Ocean and GetClouder using Ubuntu 14.04 LTS droplets / containers.
Please let me know if you encounter any issues: karmacrypto@gmail.com.

### Todo

* Add setup_forging task to enable forging on each server
