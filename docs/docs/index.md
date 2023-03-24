# Welcome to Entrance

Entrance is an authentication solution for OpenSSH that uses blockchain as the
underlying infrastructure to manage users and keys. Leveraging
blockchain means that we don't have to run your own
infrastructure for a central component that handle your SSO.

Instead of using OpenLDAP and mess around with CN/SN/DN, we can manage
entire of your server fleet by executing smart contract. We don't even
need a UI or Dashboard because we can execute the contract directly
anywhere as long as we have a wallet.

## What

Usually, whenever we want to allow a user SSH into a server, we need to
created a user for them. Then give them the password, or more securely
we add their public key into `~/.ssh/authorized_keys` file.

On top of that, we want to assign user to group, such as allow them to
run `sudo`, add them to `docker` group so they can run `docker` without
root.

Entrance is a way to store this data, username, userid and their group
etc on a blockchain. Through blockchain, we can manage their public
keys. At the same time, this also serve as an auditlog because we will
have a built-in, immutable audit-trail of who modified what at which
time.


## Why

Manage users and SSH keys quickly becomes cumbersom when there is more than a
handful of servers. This is when Chef/Ansible comes in to place to
manage users and their public key.

Manage user this way means that every server has their own view of users
and can be out of sync between servers. To add a new user on every
servers, we have to execute Chef or Ansible to apply these. So to
mitigate this and ensure all server has a consistent set of user

## Is it safe to store public key on-chain

Yes, it's public key. People have been distributing public key on key
server for years. Anyone who uses Github also have their key public
viewable by anybody.

Example, this is [Pokadot's founder Gavin's public key](https://api.github.com/users/gavofyork/keys)


## How it works

To allow a user login to a server through OpenSSH, there are 2 phases.

1. Identify user
2. Validate user

### Identify user

When you run `ssh alice@server-ip`, the username `alice` is send to
server. This username is used to query information about the user. If a
user doesn't exist on the server, you will get a `Permission Error` but
when tailing log on server.
* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.


## Get Support

There are 2 ways to achieve support for your Entrance installation.

### Commercial Support

### Community Support

Join our [discord channel](https://discord.gg/KEQnvapjC2) to dicuss and
get help from community.


