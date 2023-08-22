# sync-remote

Problem: I often work in several different machines, code editing in all of them. Sometimes, there are changes in my local git repositories that I am not ready to commit to the remote server, but at the same time I want these changes to be present in the machines that I'm working. A solution for this issue is to use rsync. But rsync has a complicated syntax, which is difficult to remember. 

sync-remote solves my problem. It essentially is a wrapper to rsync that works with local git repositories. It will synchronize only the modified files in the repository. To use it, it is very simple. To sync by pushing your changes:

```bash
sync-remote push user@server:directory
```

And to sync by pulling the changes:

```bash
sync-remote pull user@server:directory
```

# Installation

You can download `sync-remote.sh`, rename it and make it executable (`chmod +x`), or use the install script (`install.sh`):

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/arthursn/sync-remote/master/install.sh)"
```

This will install sync-remote in `$HOME/.local/bin`.

To update sync-remote to its newest version, simply run:

```bash
sync-remote update
```
