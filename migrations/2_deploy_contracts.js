const BCYMarket = artifacts.require("BCYMarket");
const ERC20 = artifacts.require("ERC20"); 

const Web3 = require('web3');


module.exports = function (deployer) {
  deployer.deploy(BCYMarket).then(async (deployedMarket) => {
    // Access the deployed contract instance using the "deployedMarket" variable
    console.log("BCYMarket contract address:", deployedMarket.address);

    const listingfee = Web3.utils.toWei("0.001", "ether");
    const price = Web3.utils.toWei("0.001", "ether");

    try {
      // Call the createMarketItem function in the BCYMarket contract
       // Call a function in the BCYMarket contract
    const result = await deployedMarket.createMarketItem("ipfs://QmRZQV9s3RPcGKkW1FbqrTbRY5NAPvSQ7HihPcT1m86UjU/1.json",price,{ value: listingfee }); 

      console.log("createMarketItem function executed successfully. New tokenId:", result);
    } catch (error) {
      console.error("Error calling the createMarketItem function:", error);
    }
    
  });
};




//0x3ddC9d08921E4f9E4CA3b40b0CEaBea61b6333C2