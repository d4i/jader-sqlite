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
    $ brew install sqlite nkf
    $ sudo easy_install pip
    $ sudo pip install -U csvkit
    ```

2.  Check out `jader-sqlite`

    ```sh
    $ git clone https://github.com/dceoy/jader-sqlite.git
    $ cd jader-sqlite
    ```

Automated Migration
-------------------

```sh
$ ./migrate /path/to/pmdacasereport20????.zip
```

Manual Migration
----------------

```sh
$ mkdir raw/ seed/ db/
$ unzip /path/to/pmdacasereport20????.zip -d raw/
$ awk '$1 == "-" { print $2 }' table_list.yml \
    | xargs -I {} bash -c 'nkf -w raw/{}20????.csv | tail -n +2 | csvformat -d , -D $ -b > seed/{}.utf8'
$ cat schema_jader.sql | sqlite3 db/jader.sqlite3
$ awk '$1 == "-" { print $2 }' table_list.yml \
    | xargs -I {} sqlite3 -separator $ db/jader.sqlite3 '.import seed/{}.utf8 {}'
$ sqlite3 db/jader.sqlite3 '.dump' | gzip - > db/dump_jader.sql.gz
```
