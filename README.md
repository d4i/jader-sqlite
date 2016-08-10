JADER-SQLite
============

Using JADER (Japanese Adverse Drug Event Report) with SQLite3

Supported JADER version: Nov. 2015

Preparation
-----------

1.  Install SQLite3, NKF, and CSVKit

    ```sh
    # Ubuntu
    $ sudo apt-get -y install sqlite3 nkf python-pip
    $ sudo pip install csvkit

    # CentOS
    $ sudo yum -y install sqlite nkf python-pip
    $ sudo pip install csvkit

    # Fedora
    $ sudo dnf -y install sqlite nkf python-pip
    $ sudo pip install csvkit

    # Homebrew on MacOSX
    $ brew install gnu-sed sqlite nkf
    $ sudo easy_install pip
    $ sudo pip install -U csvkit
    ```

2.  Check out `jader-sqlite`

    ```sh
    $ git clone https://github.com/dceoy/jader-sqlite.git
    $ cd jader-sqlite
    ```

Migration
---------

`create_db.sh` create an SQLite3 database in `db` directory and migrate data to it.  
Run `./create_db.sh --help` for the usage on a command.

```sh
$ ./create_db.sh --zip /path/to/pmdacasereport20????.zip
```
