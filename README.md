# OpenUEM - Debian Agent Installer

Repository containing the logic to build the OpenUEM agent for Debian based distributions

## Requirements

You need to have [Go installed](https://go.dev/doc/install) and the go command must be available in `/usr/local/go/bin`

## Create a new version

If you've just cloned the repository, you must run the following command:

```
git submodule init
```

Every time you run the installer, update the required submodules (openuem-agent and openuem-agent-updater) that will be compiled and copied to the installer

```
git submodule update --remote --recursive
```

Now let's run the shell script command **specifying the version number and the architecture**:

```
sudo ./create_installer.sh 0.7.0 amd64
```

The .deb package will be available at the output folder
