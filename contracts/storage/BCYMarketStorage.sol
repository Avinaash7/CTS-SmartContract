// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../types/DataTypes.sol";


contract CXEMarketStorage {

    /// @dev Owner is the contract address that created the smart contract
    address payable owner;
    /// @dev
    uint256 public rate = 100 * 10 ** 18;
    /// @dev The gee charged by the ecommerce to be allowed to list an NFT
    uint256 listPrice = 0.001 ether;
    /// @dev This mapping mas tokenId to the NFT info and is helpful when retrieving details about a tokenId
    mapping(uint256 => DataTypes.MarketItem) internal idToListedToken;
    
}