# gh.sh
Greenhouse.  
Environment variables exports manager

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

# Insert/update multiple in specific file - Verbose
bash ./gh.sh -v insert SOME_PROP some_value OTHER_PROP other_value -- "~/.profile"
```

Return examples with `-v` (verbose) flag:

```sh
[modified] export SOME_PROP=some_value
[inserted] export OTHER_PROP=other_value
```

### Delete

```sh
# Delete single
bash ./gh.sh delete SOME_PROP

# Delete multiple
bash ./gh.sh delete SOME_PROP OTHER_PROP  # ...

# Delete multiple in specific file
bash ./gh.sh delete SOME_PROP OTHER_PROP -- "~/.bash_profile"

# Delete multiple in specific file - Verbose
bash ./gh.sh -v delete SOME_PROP OTHER_PROP -- "~/.bash_profile"
```

Return examples with `-v` (verbose) flag:

```sh
[deleted] export SOME_PROP
[not found] export SOME_PROP
```

### Search

```sh
# Search single
bash ./gh.sh search SOME_PROP

# Search multiple
bash ./gh.sh search SOME_PROP 

# Search multiple in specific file
bash ./gh.sh insert SOME_PROP OTHER_PROP -- "~/.profile"
```

Return examples:

```sh
export SOME_PROP=some_value
export OTHER_PROP=other_value
""    # (empty string if not found)
```

## Source

To use gh's functions in another file — source `gh.sh` into an existing shell file and use its functions.  
*N.b:* Functions and global variables are *namespaced* with the `gh_` prefix.)

<sub>app.sh</sub>

```sh
#!/bin/bash
# ...

# Import greenhouse functions
source "./gh.sh"  # or use absolute path

# When needed, switch to another file:
gh_file ~/.profile
# PS: Don't use "quotes" if you use the ~ tilda $HOME alias

myVar="test"

# Insert, update (silent):
gh_insert SOME_PROP "$myVar"

# Verbose insert, update:
gh_insertv SOME_PROP "$myVar" OTHER_PROP other_value PORT 8080
#> [modified] export SOME_PROP=test
#> [inserted] export OTHER_PROP=other_value
#> [inserted] export PORT=8080

# Quote literally and escape as needed:
gh_insertv OTHER_PROP "\"\$HOME\/.nvm\""
#> [modified] export OTHER_PROP="$HOME/.nvm"

# Delete (silent)
gh_delete "SOME_PROP"

# Verbose delete
gh_deletev "OTHER_PROP"
#> [deleted] export OTHER_PROP

gh_search "PORT"
#> export PORT=8080

gh_search "NONEXISTENT"
#>

# Check the currently operated file path
echo $gh_rcFile 
#> ~/.profile

# ...
```

### Error messages  

When an error is encountered, even in silent mode (non `-v` verbose), you can expect this error messages format:

```sh
[error] Some caught error message
```

## Licence

MIT
