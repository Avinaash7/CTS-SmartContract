const BCYMarket = artifacts.require("BCYMarket");
const ERC20 = artifacts.require("ERC20"); 

const Web3 = require('web3');
const contract = require('@truffle/contract');

module.exports = function (deployer) {
  deployer.deploy(BCYMarket);
};


//0x3ddC9d08921E4f9E4CA3b40b0CEaBea61b6333C2