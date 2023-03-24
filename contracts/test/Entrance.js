const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

const { ethers } = require("hardhat");

describe("Entrance", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, alice, bob] = await ethers.getSigners();

    const Entrance = await ethers.getContractFactory("Entrance");
    const entrance = await Entrance.deploy();

    return { entrance, owner, alice, bob };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { entrance, owner } = await loadFixture(deployFixture);

      expect(await entrance.owner()).to.equal(owner.address);
    });

    //it("Should receive and store the funds to lock", async function () {
    //  const { lock, lockedAmount } = await loadFixture(
    //    deployFixture
    //  );

    //  expect(await ethers.provider.getBalance(lock.address)).to.equal(
    //    lockedAmount
    //  );
    //});
  });

  describe("Create Deployment", function() {
    it("add a new deployment and set owner as admin", async function () {
      const { entrance, owner } = await loadFixture(deployFixture);

      const cluster_name = ethers.utils.formatBytes32String("test1");
      await entrance.create_deployment(cluster_name);

      const deps = await entrance.list_deployments();
      expect(ethers.utils.parseBytes32String(deps[0])).to.equal("test1");

      const dep = await entrance.get_deployment(cluster_name);
      expect(dep.admins[0]).to.equal(owner.address);
    })
  })

  describe("Add user", function() {
    it("should reject if not an admin of deployment", async function() {
      const { entrance, owner, alice, bob } = await loadFixture(deployFixture);


      const cluster_name = ethers.utils.formatBytes32String("test1");
      await entrance.create_deployment(cluster_name);

      const alice_name = ethers.utils.formatBytes32String("alice");
      await expect(entrance.connect(bob).add_user(cluster_name, alice.address, alice_name))
                    .to.be.revertedWith('you arent an admin');

      const dep = await entrance.get_deployment(cluster_name);
    })

    it("store the address and username", async function() {
      const { entrance, owner, alice, bob } = await loadFixture(deployFixture);


      const cluster_name = ethers.utils.formatBytes32String("test1");
      await entrance.create_deployment(cluster_name);

      const alice_name = ethers.utils.formatBytes32String("alice");
      await entrance.add_user(cluster_name, alice.address, alice_name);

      const dep = await entrance.get_deployment(cluster_name);

      expect(dep.username[0]).to.equal(alice_name);
      expect(dep.user_address[0]).to.equal(alice.address);
    })

    it("accept username with many wallet address", async function() {
      const { entrance, owner, alice, bob } = await loadFixture(deployFixture);


      const cluster_name = ethers.utils.formatBytes32String("test1");
      await entrance.create_deployment(cluster_name);

      const alice_name = ethers.utils.formatBytes32String("alice");
      const bob_name = ethers.utils.formatBytes32String("bob");
      await entrance.add_user(cluster_name, alice.address, alice_name);
      await entrance.add_user(cluster_name, alice.address, bob_name);

      const dep = await entrance.get_deployment(cluster_name);

      expect(dep.username[0]).to.equal(alice_name);
      expect(dep.user_address[0]).to.equal(alice.address);

      expect(dep.username[1]).to.equal(bob_name);
      expect(dep.user_address[0]).to.equal(alice.address);
    })
  })

  describe("Add Key", function() {
    it("should reject if not an admin or user owner", async function() {
      const { entrance, owner, alice, bob } = await loadFixture(deployFixture);

      const cluster_name = ethers.utils.formatBytes32String("test1");
      await entrance.create_deployment(cluster_name);

      const alice_name = ethers.utils.formatBytes32String("alice");
      await expect(entrance.connect(bob).add_key(cluster_name, alice_name, "123"))
                    .to.be.revertedWith('not an admin or not the owner of this username');
    })

    it("should let cluster admin add any key", async function() {
      const { entrance, owner, alice, bob } = await loadFixture(deployFixture);

      const cluster_name = ethers.utils.formatBytes32String("test1");
      const alice_name = ethers.utils.formatBytes32String("alice");

      await entrance.connect(bob).create_deployment(cluster_name);
      await entrance.connect(bob).add_user(cluster_name, alice.address, alice_name);


      await expect(entrance.connect(bob).add_key(cluster_name, alice_name, "123"))
                    .not.to.be.reverted;

      await expect(entrance.connect(alice).add_key(cluster_name, alice_name, "456"))
        .not.to.be.reverted;

      const keys = await entrance.get_key(cluster_name, alice_name);
      expect(keys[0]).to.equal("123");
      expect(keys[1]).to.equal("456");
    })
  })

  describe("Remove Key", function() {
    it("should reject if not an admin or user owner", async function() {
      const { entrance, owner, alice, bob } = await loadFixture(deployFixture);

      const cluster_name = ethers.utils.formatBytes32String("test1");
      await entrance.create_deployment(cluster_name);

      const alice_name = ethers.utils.formatBytes32String("alice");
      await expect(entrance.connect(bob).remove_key(cluster_name, alice_name, "123"))
                    .to.be.revertedWith('not an admin or not the owner of this username');
    })

    it("remove key from registry", async function() {
      const { entrance, owner, alice, bob } = await loadFixture(deployFixture);

      const cluster_name = ethers.utils.formatBytes32String("test1");
      const alice_name = ethers.utils.formatBytes32String("alice");

      await entrance.create_deployment(cluster_name);
      await entrance.add_user(cluster_name, alice.address, alice_name);
      await expect(entrance.add_key(cluster_name, alice_name, "123"))
                    .not.to.be.reverted;
      await expect(entrance.connect(alice).add_key(cluster_name, alice_name, "456"))
        .not.to.be.reverted;

      expect(await entrance.connect(alice).remove_key(cluster_name, alice_name, "123")).not.to.be.reverted;

      const keys = await entrance.get_key(cluster_name, alice_name);
      console.log(keys);
      expect(keys.length).to.equal(1);
      expect(keys[0]).to.equal("456");
    })
  })


  describe("formt", function() {
    it("log", async function() {
      const alice_name = ethers.utils.formatBytes32String("blue");
      const root = ethers.utils.formatBytes32String("root");
    })
  })
});
