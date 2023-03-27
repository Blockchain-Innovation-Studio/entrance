# Entrance

entrance is how OpenStory manage our SSH Authentication infrastructure.

# Why

OpenStory has developed a unique solution called Entrance to manage the SSH Authentication infrastructure. When it comes to companies that manage large-scale server deployments, it's crucial to manage and define how users can SSH into the server. Automation tools can help manage and populate this data. However, whenever there is a new user onboarded or a key rotated, two steps must be taken: populating the data storage and triggering a run of the automation tool to populate those keys. Some companies use certificate-based authentication to manage this process, but it is different from the normal public/private key and requires generating and provisioning the cert.

LDAP and PAM are other options that run on top of NSS, but the question arises: How can we bootstrap SSH key management for those central servers? How can we ensure their uptime? How do we manage audit logs? The answer lies in blockchain technology. By leveraging the ability of the blockchain to provide an immutable and traceable record of every action, OpenStory has created a solution that manages key and user directly on the blockchain while having a full audit trail of the action.

# How it works

Here's how it works: Entrance stores user public keys on the blockchain. When a user logs in, instead of looking into the default $HOME/.ssh/authorized_keys, the system fetches the key from the blockchain for that user. Entrance uses the AuthorizedKeysCommand to run its custom program that extracts the public key from the blockchain. The system comprises three components: the blockchain, the AuthorizedKeysCommand program, and the SSH server.

## Blockchain

The blockchain component is a contract that stores the public key on the chain. OpenStory recommends using EDDSA, but RSA or DSA also work. A deployment is a cluster of servers, and each user belongs to a deployment and has one or many keys.

## AuthorizedKeysCommand program

The AuthorizedKeysCommand program is a binary that needs to be deployed into the target computer. SSH needs to be configured to run this program. In the /etc/ssh/sshd_config file, add the following lines:

AuthorizedKeysCommand /usr/bin/entrance -deployment=[deployment-name] -user=%u
AuthorizedKeysCommandUser nobody

Make sure to replace [deployment-name] with the name of your deployment.

# Getting started

To get started, you need to deploy a contract. If you want to experiment, you can use OpenStory's contract without deploying your own. The contract is deployed on the Polygon network at a specific address. 

## Creating the deployment

After having the contract, execute the create_deployment method to create a deployment.


```
create_deployment

input: deployment, need to be unique. The execution will error out if the name already exists, 
so make sure to pick a unique name to save gas
```

To find an existing deployment, use the `list_deployment` method.

The person who executes the contract becomes the admin of this deployment. 
To add more admins, run the add_admin method.

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

## Manage keys


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
