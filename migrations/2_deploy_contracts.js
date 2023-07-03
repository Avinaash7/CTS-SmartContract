const BCYMarket = artifacts.require("BCYMarket");
const ERC20 = artifacts.require("ERC20"); 

module.exports = function (deployer) {
  deployer.deploy(BCYMarket);
};