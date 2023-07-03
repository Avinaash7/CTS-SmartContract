const BCYMarket = artifacts.require("BCYMarket");
const ERC20 = artifacts.require("ERC20"); 

module.exports = function (deployer, network, accounts) {
  deployer.deploy(BCYMarket, ERC20.address, { from: accounts[0] });
};