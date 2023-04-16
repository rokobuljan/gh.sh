#!/bin/bash
#
# gh
#
# A greenhouse utility for managing your environment (exports)
# Inserts, modify and delete ~/.bashrc (or another file's) exports like:
# export PROPERTY=value

gh_version="v1.0.0"

gh_usage() {
    echo -e "gh $gh_version
Usage:
    insert [[PROPERTY value] ...]
    delete [PROPERTY ...]
    search [PROPERTY ...]
    [-- file]
Examples:
    bash ./gh.sh insert SOME_PROP someValue OTHER_PROP otherValue  # [inserted] [updated]
    bash ./gh.sh delete SOME_PROP  # [deleted] [not found]
    bash ./gh.sh search SOME_PROP | awk -F '=' '{print \$2}'  # value
    bash ./gh.sh search SOME_PROP -- .profiles  # export SOME_PROP=value | [not found]
Using source and gh functions:
    source ./gh.sh
    gh_insert \"SOME_PROP\" \"some_value\"
    gh_delete \"SOME_PROP\"
    gh_file .profile  # Switch to another file
    gh_search \"PORT\"  # 5432
    echo \$gh_rcFile  # Check current file path
Notice:
    gh does not creates rc files, so make sure the file exists.
    Make sure to not insert multiline values or your program might fail.
"
}

gh_file() {
    # Make sure the rc file exists
    if ! [[ -f "$1" ]]; then
        echo "[error] File \"$1\" does not exist"
        gh_usage
        exit 1
    fi
    gh_rcFile=$1
}

gh_insert() {
    if (( $# % 2 != 0 )); then
        echo "[error] Invalid number of arguments. At least two arguments needed"
        gh_usage
        return 1
    fi

    local prop=""
    local val=""

    for ((i = 1; i < $#; i += 2)); do
        i2="$((i + 1))"
        prop="${!i}"
        val="${!i2}"
        if grep -q "^export $prop=" "$gh_rcFile"; then
            sed -i "s/^export $prop=.*$/export $prop=$val/" "$gh_rcFile" &&
            echo "[updated] export $prop=$val"
        else
            echo -e "export $prop=$val" >> "$gh_rcFile"
            echo "[inserted] export $prop=$val"
        fi
    done
}

gh_delete() {
    if (( $# < 1 )); then
        echo "[error] Invalid number of arguments. At least one property name to delete is needed"
        gh_usage
        return 1
    fi

    local prop=""

    for prop in "$@"; do
        if grep -q "^export $prop=" "$gh_rcFile"; then
            sed -i "/^export $prop=.*$/d" "$gh_rcFile" &&
            echo "[deleted] $prop"
        else
            echo "[not found] $prop"
        fi
    done
}

gh_search() {
    if (( $# < 1 )); then
        echo "[error] Invalid number of arguments. At least one property name to search is needed"
        gh_usage
        return 1
    fi

    local prop=""

    for prop in "$@"; do
        grep "^export ${prop}=" "$gh_rcFile" || echo "[not found] $prop"
    done
}

gh_main() {

    if [[ "$#" -lt 2 ]]; then
        gh_usage && exit 0
    fi

    local method=$1

    if ! [[ "$method" =~ ^(insert|delete|search|file)$ ]]; then
        echo "[error] Invalid method $method"
        gh_usage
        exit 1
    fi

    # Remove method name from arguments
    shift

    local args="$@"
    # Collect -- delimiter and file
    local argLast="${*: -1:1}"
    local argSubLast="${*: -2:1}"

    if [[ "$argSubLast" = "--" ]] && [[ -n "$argLast" ]]; then
        # Set custom file
        gh_file "$argLast"
        # remove file related args
        args="${args% --*}"
    else
        # default to .bashrc file
        gh_file ".bashrc"
    fi

    [[ "$method" = "insert" ]] && gh_insert $args;
    [[ "$method" = "delete" ]] && gh_delete $args;
    [[ "$method" = "search" ]] && gh_search $args;
    [[ "$method" = "file" ]] && gh_file $args;
}

# If script is not sourced (main), use options instead of functions:
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    gh_main "$@"
fi
