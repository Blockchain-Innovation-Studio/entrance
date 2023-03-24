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
mitigate this and ensure all server has a consistent set of user.

On top of that, we also need to be careful to make sure the user id and
group id is consistent between server.

Regardless, this isn't an efficient system because it requires computing
time to change state of every server.

Because of that, people starts to use PAM/NSS such as OpenLDAP to
centralize user and key management. However, how do we login to LDAP
server at first place? How do we secure access to LDAP web ui? It's
turtle on the way down.

How do we ensure uptime of the SSO server? We know introduce a single
point of failure  into our system.

By leveraging blockchain to store this data, we solve a few problems:

- There is no need to dashboard or UI. Executing contracts is faily
  common on blockchain. Etherscan supports it beside many other tool.
- Authentication is done for us based on user wallet.
- Built in Audit Trail: we have a full trails of who adds what on when
- Highly available: The uptime of the system is the uptime of the RPC
  node. There are many RPC services to use


## FAQ

### Is it safe to store public key on-chain

Yes, it's public key. People have been distributing public key on key
server for years. Anyone who uses Github also have their key public
viewable by anybody.

Example, this is [Pokadot's founder Gavin's public key](https://api.github.com/users/gavofyork/keys)

### How much does it cost

The only cost is whenever you write to blockchain including:

- deloy the smart contract. You can optinally use our deployed contract
  directly too.
- write data to blockchain such as adding admin, add user, add/delete
 public key

### Can I continue to use entrance if you are disappear tomorrow

Yes, this is blockchain strongsuit. Once the code is deployed to the
chain, and data is added, it stays there forever. Reading from
blockchain is always free, all you need is a RPC node

### Do I need to know Solidity

No. Simply use our own deployed contract. It's safe and secure. You can
create a cluster which you and only you have permission to manage it.

## Get Support

If you don't want to deploy a smart contract yourself, we can  help.

There are 2 ways to achieve support for your Entrance installation.

### Commercial Support

We plan to do commercial support and will built SaaS with dashboard and
UI to help you deploy the contract and manage the infra from our UI.
Note that this is optinal, our SaaS offering is just a nice UI layer.
You can keep managing directly by executing the contract function on
etherscan or any wallet that support execute smart contract.

### Community Support

Join our [discord channel](https://discord.gg/KEQnvapjC2) to dicuss and
get help from community.
