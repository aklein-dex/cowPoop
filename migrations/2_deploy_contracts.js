var CowPoop = artifacts.require("./CowPoop.sol");

module.exports = function(deployer, network, accounts) {
  const adminAddress = accounts[0];
  console.log(`Admin address: ${adminAddress}`);
  deployer.deploy(CowPoop, adminAddress);
};
