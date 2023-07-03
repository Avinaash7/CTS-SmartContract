// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract DataTypes {
    
    /// @notice The structure to store info about a listed Item
    struct MarketItem {
        uint tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }
}