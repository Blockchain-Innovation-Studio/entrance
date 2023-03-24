// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Entrance {
    address public owner;

    struct User {
      bytes32 name;
      bytes32[] keys;
    }

    struct Deployment {
      address[] admins;
      address[] user_address;
      bytes32[] username;
    }

    event CreateDeploy(bytes32 indexed _name, address _admin);

    // list of all clusters
    bytes32[] clusters;

    // cluster -> username -> list of key
    mapping(bytes32 => mapping(bytes32 => string[])) cluster_keys;

    // cluster name => list of linux username
    mapping(bytes32 => bytes32[]) cluster_usernames;

    // cluster_name => list of wallet address
    mapping(bytes32 => address[]) cluster_user_address;

    // cluster -> list of admin
    mapping(bytes32 => address[]) cluster_admins;

    constructor() {
        owner = msg.sender;
    }

    // deployment
    function s_create_deployment(string memory name) public {
      bytes32 cluster_name = stringToBytes32(name);

      create_deployment(cluster_name);
    }

    function create_deployment(bytes32 name) public {
        clusters.push(name);
        cluster_admins[name].push(msg.sender);

        //emit CreateDeploy(address(this).balance, block.timestamp);
    }

    function list_deployments() public view returns (bytes32[] memory) {
      return clusters;
    }

    function get_deployment(bytes32 name) public view returns (Deployment memory) {
      Deployment memory d = Deployment({
        admins: cluster_admins[name],
        username: cluster_usernames[name],
        user_address: cluster_user_address[name]
      });

      return d;
    }

    function s_add_user(string memory cluster_name, address user_address, string memory username) public {
      bytes32 b_cluster_name = stringToBytes32(cluster_name);
      bytes32 b_username     = stringToBytes32(username);
      add_user(b_cluster_name, user_address, b_username);
    }

    function add_user(bytes32 cluster_name, address user_address, bytes32 username) public {
      require(check_cluster_admin(cluster_name) == true, "you arent an admin");

      // see if the user address already in
      for (uint i = 0; i < cluster_user_address[cluster_name].length; i++) {
        if (cluster_user_address[cluster_name][i] == user_address) {
          if (cluster_usernames[cluster_name][i] == username) {
            return;
          }
        }
      }

      cluster_user_address[cluster_name].push(user_address);
      cluster_usernames[cluster_name].push(username);
    }

    // keys
    function s_add_key(string memory cluster_name, string memory username, string memory key) public {
      bytes32 b_cluster_name = stringToBytes32(cluster_name);
      bytes32 b_username     = stringToBytes32(username);
      add_key(b_cluster_name,  b_username, key);
    }

    // keys
    function s_remove_key(string memory cluster_name, string memory username, string memory key) public {
      bytes32 b_cluster_name = stringToBytes32(cluster_name);
      bytes32 b_username     = stringToBytes32(username);
      remove_key(b_cluster_name,  b_username, key);
    }

    function add_key(bytes32 cluster_name, bytes32 username, string memory key) public {
      bool can_add_key = check_cluster_admin(cluster_name);

      if (!can_add_key) {
        // check if caller is the owner of the user
        for (uint i = 0; i < cluster_user_address[cluster_name].length; i++) {
          if (cluster_user_address[cluster_name][i] == msg.sender) {
            if (cluster_usernames[cluster_name][i] == username) {
              can_add_key = true;
              break;
            }
          }
        }
      }

      require(can_add_key, "not an admin or not the owner of this username");

      cluster_keys[cluster_name][username].push(key);
    }

    function remove_key(bytes32 cluster_name, bytes32 username, string memory key) public {
      bool can_add_key = check_cluster_admin(cluster_name);

      if (!can_add_key) {
        // check if caller is the owner of the user
        for (uint i = 0; i < cluster_user_address[cluster_name].length; i++) {
          if (cluster_user_address[cluster_name][i] == msg.sender) {
            if (cluster_usernames[cluster_name][i] == username) {
              can_add_key = true;
              break;
            }
          }
        }
      }

      require(can_add_key, "not an admin or not the owner of this username");

      // find the key position
      cluster_keys[cluster_name][username].push(key);
      int pos = _find_key(cluster_name, username, key);

      if (pos >= 0) {
        _burn_key(cluster_name, username, uint(pos));
      }
    }


    function s_get_key(string memory cluster_name, string memory username) public view returns (string[] memory) {
      bytes32 b_cluster_name = stringToBytes32(cluster_name);
      bytes32 b_username     = stringToBytes32(username);
      return cluster_keys[b_cluster_name][b_username];
    }


    function get_key(bytes32 cluster_name, bytes32 username) public view returns (string[] memory) {
      return cluster_keys[cluster_name][username];
    }

    // cheap and fast method to delete an element by swap its value with the last element then delete the last element
    // which hold its value now
    // we don't need to keep ordering of this array
    function _burn_key(bytes32 cluster_name, bytes32 username, uint index) internal {
      require(index < cluster_keys[cluster_name][username].length);

      cluster_keys[cluster_name][username][index] = cluster_keys[cluster_name][username][cluster_keys[cluster_name][username].length-1];

      cluster_keys[cluster_name][username].pop();
    }

    function _find_key(bytes32 cluster_name, bytes32 username, string memory key) internal view returns (int) {
      for (uint i =0; i < cluster_keys[cluster_name][username].length; i++) {
        if (compare(cluster_keys[cluster_name][username][i], key)) {
          return int(i);
        }
      }

      return -1;
    }

    function check_cluster_admin(bytes32 name) public view returns (bool) {
      for (uint i = 0; i < cluster_admins[name].length; i++) {
        if (cluster_admins[name][i] == msg.sender) {
            return true;
        }
      }

      return false;
    }

    function check() public view {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(msg.sender == owner, "You aren't the owner");
    }

    // bytes32 is more efficient while string is more userfieldly
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function compare(string memory str1, string memory str2) internal pure returns (bool) {
        if (bytes(str1).length != bytes(str2).length) {
            return false;
        }
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }
}
