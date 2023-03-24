require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",

  networks: {
    sepolia: {
      url: process.env.TESTNET_NODE_URL,
      accounts: [
        process.env.DMZ_PRIVATE_KEY,
      ],
    }
  }
};
