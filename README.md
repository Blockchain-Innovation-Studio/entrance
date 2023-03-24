# Entrance

entrance is how OpenStory manage our SSH Authentication infrastructure.

# Why

Any companies that manage a large scale deployment of server will need
to manage and define how user can SSH into the server. There is all
kind of automation tools to manage and populate this data. Everytime a
new user onboard or rotate key there are 2 steps:

- populate the data stoage
- trigger a run of the automationtool to populate those keys.

Certain company use certificate based to manage this and solve these
pain points. But cert based is different from the normal public/private
key and have to deal with generate and provision the cert.

There is also LDAP and PAM, run on top of NSS.

But then how can we bootstrap SSH key management for those central
servers, how we ensure their uptime? How do we manage audit log.

BlockChain to the rescues. We leverage the ability of immutable,
traceable of every actions to manage key and user directly on the
blockchain, also having a full audit trait of the action


# How it works

We stored user public keys on the blockchain. When user login, instead
of looking into the default `$HOME/.ssh/authorized_keys` we fetch the
key from the blockchain for t hat user.

We use [AuthorizedKeysCommand](https://man.openbsd.org/sshd_config#AuthorizedKeysCommand)
to run our custom program that extract the public key from the
blockchain.

The system include 3 components:

## Blockchain

A contract to store the public key on chain. We use below concepts:

- deployment: a deployment is a cluster of server
- user: a user belong to a deployment, a user have one or many key
- key: a public key is stored on-chain. we recomend EDDSA but RSA or DSA
  also work.

## AuthorizedKeysCommand program

This is binary that needs to deploy into the target computer. And the
SSH needs to be configured this way:

```
# /etc/ssh/sshd_config

AuthorizedKeysCommand /usr/bin/entrance -deployment=[deployment-name] -user=%u
AuthorizedKeysCommandUser nobody
```


# Getting started

To start with, you would need to deploy a contract. To
experiment, you can use our contract without deploying your own. The
contract is deployed on Polygon network at this address:

## Creating the deployment

After having the contract, execute this method:


```
create_deployment

input: deployment, need to be unique. The execution error out if a name
is already existed. So make sure to pick some randome, unique enough
name to save gas
```

To find existing deployment you can use `list_deployment`.

The person who executed the contract become the admin of this
deployment, to add more admin run method

```
add_admin

input:
    - deployment nam
    - new admin address
```


Upon having a deployment you're ready to configure your SSH to use it

## Configure SSH server

Edit  **/etc/ssh/sshd_config** and add these line:

```
AuthorizedKeysCommand /usr/bin/entrance -deployment=[deployment-name] -user=%u
AuthorizedKeysCommandUser nobody
```

make sure you put the right `deployment-name`

## Manage key

At this point you have a deployment, and the SSH server with the right
config. To add user or key to a deployment, simply run:

```
add_key

input:
  deployment_name:
  username: this is ssh of username on server
  public_key: the public key
```

This method can run multiple times to add new key to server

To remove a key from a user, run `remove_key`


We're done. Try to SSH into any server, if it doesn't work, tail the log
in `/var/log/auth.log
