# gh.sh
Greenhouse.  
Env variables exports manager

Insert, modify, delete your `~/.bashrc` (or any other file's) environment variables exports like i.e:

```sh
#!/bin/bash
# This is ~/.bashrc
# ...
export POSTGRES_PORT=5432
export DISPLAY=:0
export WAYLAND_DISPLAY=wayland-1
```

## CLI

### Insert &amp; update

Insert or modify an env variable export

```sh
# Insert/update single
bash ./gh.sh insert SOME_PROP some_value

# Insert/update single 
bash ./gh.sh insert SOME_PROP some_value OTHER_PROP other_value 

# Insert/update multiple in specific file
bash ./gh.sh insert SOME_PROP some_value OTHER_PROP other_value -- "~/.profile"
```

**Returns**

```sh
[inserted] SOME_PROP=some_value
```
or for multiple:
```sh
[modified] SOME_PROP=some_value
[inserted] OTHER_PROP=other_value
```

### Delete

```sh
# Delete single
bash ./gh.sh delete SOME_PROP

# Delete multiple
bash ./gh.sh delete SOME_PROP OTHER_PROP  # ...

# Delete multiple in specific file
bash ./gh.sh delete SOME_PROP OTHER_PROP -- "~/.bash_profile"
```

**Returns**

### Search

```sh
# Search single
bash ./gh.sh search SOME_PROP

# Search multiple
bash ./gh.sh search SOME_PROP 

# Search multiple in specific file
bash ./gh.sh insert SOME_PROP OTHER_PROP -- "~/.profile"
```
Returns

```sh
export SOME_PROP=some_value
```
```sh
export SOME_PROP=some_value
export OTHER_PROP=other_value
```

## Source

To use gh's functions in another file — source `gh.sh` into an existing shell file and use its functions.  
*N.b:* Functions and global variables are *namespaced* with the `gh_` prefix.)

<sub>app.sh</sub>
```
#!/bin/bash
# ...

source "./gh.sh"  # or use absolute path

gh_insert \"SOME_PROP\" \"some_value\"
gh_insert \"SOME_PROP\" \"some_value\" SOME_OTHER_PROP other_value

gh_delete \"SOME_OTHER_PROP\"

gh_file .profile    # Switch to another file

gh_search \"PORT\"  # 8080

echo \$gh_rcFile    # Check current file path

# ...
```

## Licence

MIT

Disclaimer: Always test before using.
