// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../types/DataTypes.sol";

interface IBCYMarket {
    
    /// @notice Emitted when a market item has been created succesfully
    /// @dev When a item is created, should show the item into the market
    event ItemListedSuccess (
        uint256 indexed tokenId,
        address owner,
        address seller,
        uint256 price,
        bool currentlyListed
    );

    /// @notice
    /// @dev
    /// @param _listPrice Is the price that the user wants to change their item
    function updatePrice(uint256 _listPrice) external payable;

    /// @notice This function is to create a item into the ecommerce
    /// @dev Using 3 functions, the first to from OZ and the last one written below
    /// @param tokenURI is the URL that saves the Item metadata
    /// @param price is the price that the user will create their item
    function createMarketItem(string memory tokenURI, uint256 price) external payable returns(uint256);

    /// @notice This function is to remove a listed item with tokenId
    /// @dev 
    /// @param tokenId is the tokenId of the listed item.
    function removeMarketItem(uint256 tokenId) external;

    /// @notice This function is to execute the sale
    /// @dev Execute the sale with just the tokenId
    /// @param tokenId set the ID of the item to sale
    function sale(uint256 tokenId) external payable;
    
    /// @notice This function will return the price of the item listed
    /// @dev It will returns a uint256 (price)
    function getListPrice() external returns (uint256);

    /// @notice This function will return the latest item listed in the ecommerce
    /// @dev It will returns a struct
    function getLatestIdToListedItem() external returns (DataTypes.MarketItem memory);

    /// @notice This function will return the items corresponding for the ID
    /// @dev It will look for into the struct MarketItem
    function getListedItemForId(uint256 tokenId) external returns (DataTypes.MarketItem memory);

    /// @notice This function will return the current token
    /// @dev It will be a uint256
    function getCurrentToken() external returns (uint256);

    /// @notice This function will return all the NFT
    /// @dev It will look for into MarketItem struct
    function getAllNFTs() external returns (DataTypes.MarketItem[] memory);
}