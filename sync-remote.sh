#!/bin/bash

function dirnames {
    local input
    local parent
    input="$1"
    if [[ "$input" == "" ]]; then
        true
    elif [[ "$input" == "." || "$input" == "/" ]]; then
        printf '%s\n' "$input" #print the root node
    else
        #printf '%s\n' "$input"  #print node (descending)
        parent="$(dirname "$input")"
        dirnames "$parent"
        printf '%s\n' "$input" #print node (ascending)
    fi
}

make_include_string() {
    include_str=""
    dirs=()
    for f in $@; do
        for d in $(dirnames $(dirname $f)); do
            if [[ ! " ${dirs[*]} " =~ " ${d} " ]]; then
                include_str="$include_str --include=$d/"
                dirs="${dirs[@]} $d"
            fi
        done
        include_str="$include_str --include=$f"
    done
    echo $include_str
}

update() {
    echo "Updating sync-remote"
    target=$1
    wget https://raw.githubusercontent.com/arthursn/sync-remote/master/sync-remote.sh -O "$target"
    chmod +x "$target"
    echo "sync-remote updated!"
}

sync() {
    # Parse remote path (remote:remote_dir)
    IFS=':' read -ra arr <<<"$2"
    remote="${arr[0]}"
    remote_dir="${arr[1]}"
    # Check if variables are not empty
    [[ -z $remote_dir || -z $remote_dir ]] && usage

    case $1 in
    push)
        # Include all changed files that are not deleted
        files=$(git status --porcelain | awk '!match($1, "D"){print $2}')
        include_str=$(make_include_string $files)
        (
            set -x
            rsync -arvP $include_str --exclude=".*" --exclude="*" . $remote:$remote_dir/
        )
        ;;
    pull)
        # Include all changed files that are not deleted
        files=$(ssh $remote "git -C $remote_dir status --porcelain" | awk '!match($1, "D"){print $2}')
        include_str=$(make_include_string $files)
        (
            set -x
            rsync -arvP $include_str --exclude=".*" --exclude="*" $remote:$remote_dir/ .
        )
        ;;
    *)
        echo "Invalid option $1"
        exit 1
        ;;
    esac
}

usage() {
    echo "Usage: sync-remote [push pull] [remote:remote_dir]"
    exit 1
}

case $1 in
push)
    sync $@
    exit $?
    ;;
pull)
    sync $@
    exit $?
    ;;
update)
    update $0
    ;;
*)
    usage
    ;;
esac
