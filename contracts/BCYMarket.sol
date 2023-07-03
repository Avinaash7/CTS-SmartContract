// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// OpenZeppelin modules
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Custom modules
import "./interfaces/IBCYMarket.sol";
import "./types/DataTypes.sol";
import "./storage/BCYMarketStorage.sol";

contract BCYMarket is BCYMarketStorage,IBCYMarket, 
    ERC721URIStorage
    {

    using Counters for Counters.Counter;
    /// @dev _tokenIds variable has the most recent minted tokenId 
    Counters.Counter private _tokenIds;
    /// @dev Keeps track of the number of items sold on the marketplace
    Counters.Counter private _itemsSold;
    /// @dev
    IERC20 public bcyAddress;

    /**
     * @notice Constructor sets the name of the contract
     * @dev Developers can update the contract
     * TODO At the moment use normal Proxy to update, to let in the future integrate Diamond Proxy
     * NOTE Accepts only BCY to mint NFTs writing the address of the token in deployment
     */
    constructor() ERC721("BlockConvey", "BCY") {
        owner = payable(msg.sender);
        bcyAddress = IERC20(0x3608631C72fa89C27DE0F703a61907Bf945133B1);
    }

    /**
     * @notice
     * @dev
     * @param _listPrice is the price that user wants to change their item
     */
    function updatePrice(uint256 _listPrice) public payable {
        require(owner == msg.sender, "Only owner of the NFT can update the price");
        listPrice = _listPrice;
    }

    /**
     * @notice This function is to create a item into the market
     * @param tokenURI is the URL that saves the Item metadata
     * @param price is the price that the user will create their item
     */
    function createMarketItem(
        string memory tokenURI,
        uint256 price
    ) public payable returns (uint256) {
        /// @dev
        bcyAddress.transferFrom(msg.sender, address(this), rate);
        /// @dev Increment the tokenId counter
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        /// @dev Mint the NFT (item) with tokenId newTokenId to the address who called createMarketItem function
        _safeMint(msg.sender, newTokenId);
        /// @dev Map the tokenId to the tokenURI (IPFS URL saving the metadata)
        _setTokenURI(newTokenId, tokenURI);
        /// @dev Helper function to update variables and emit an event
        createListedItem(newTokenId, price);

        return newTokenId;
    }

    /**
     * @notice This function is executed inside createMarketItem
     * @dev Use one function (_transfer) to transfer the cryptocurrencies to this address (address(this))
     * @param tokenId is the Id of the item created
     * @param price is the price of the item created
     */
    function createListedItem(uint256 tokenId, uint256 price) private {
        /// @dev Make sure the msg.sender sent enough funds to pay for create item
        require(msg.value == listPrice, "Checking to send the correct price");
        require(price > 0, "The price must be more than zero");

        /// @dev Update the mapping of tokenId´s to Token details
        idToListedToken[tokenId] = DataTypes.MarketItem(
            tokenId,
            payable(address(this)),
            payable(msg.sender),
            price,
            true
        );

        _transfer(msg.sender, address(this), tokenId);

        /// @dev Announce that the item has been created
        emit ItemListedSuccess(
            tokenId,
            address(this),
            msg.sender,
            price,
            true
        );
    }

    function removeMarketItem(uint256 tokenId) external {
        address seller = idToListedToken[tokenId].seller;
        require(msg.sender == owner || msg.sender == seller,'Error, Caller is not Owner or Seller');
        _transfer(msg.sender, seller , tokenId);
        delete idToListedToken[tokenId];
    }

    /**
     * @notice This function will return all the NFTs currenty listed
     * @dev It will return the properties inserted into the struct MarketItem
     */
    function getAllNFTs() public view returns(DataTypes.MarketItem[] memory) {
        uint256 nftcount = _tokenIds.current();
        DataTypes.MarketItem[] memory tokens = new DataTypes.MarketItem[](nftcount);
        uint256 currentIndex = 0;
        uint256 currentId;

        for(uint256 i = 0; 0 < nftcount; i++) {
            currentId = i + 1;
            DataTypes.MarketItem storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }

        return tokens;
    }

    /**
     * @notice This function will returns all the NFT that the current user is owner or seller in
     * @dev Will return the properties into the struct MarketItem
     */
    function getMyNFTs() public view returns (DataTypes.MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;
        uint256 currentId;

        for(uint256 i=0; i < totalItemCount; i++) {
            if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        DataTypes.MarketItem[] memory items = new DataTypes.MarketItem[](itemCount);
        for(uint256 i=0; i < totalItemCount; i++) {
            if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender) {
                currentId = i+1;
                DataTypes.MarketItem storage currentItem = idToListedToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return items;
    }

    /**
     * @notice This function is to execute the sale
     * @dev Execute the sale with just the tokenId
     * @param tokenId set the ID of the item to sale
     */

    function sale(uint256 tokenId) public payable {
        /// @dev Set new vars
        uint256 price = idToListedToken[tokenId].price;
        address seller = idToListedToken[tokenId].seller;
        /// @dev Submit the price in order
        require(msg.value == price, "Submit the price in order");

        /// @dev Update the details of the item
        idToListedToken[tokenId].currentlyListed = true;
        idToListedToken[tokenId].seller = payable(msg.sender);
        _itemsSold.increment();    

        /// @dev Transfer the item to the buyer
        _transfer(address(this), msg.sender, tokenId);
        approve(address(this), tokenId);

        /// @dev Transfer the listing price to creator
        payable(owner).transfer(listPrice);
        payable(seller).transfer(msg.value);
    }

   

    function withdrawToken() public {
        bcyAddress.transfer(msg.sender, bcyAddress.balanceOf(address(this)));
    }

    /************************ */
    /**** GETTER FUNCTIONS ****/
    /************************ */
    
    function getListPrice() public view returns (uint256) {
        return listPrice;
    }

    function getLatestIdToListedItem() public view returns (DataTypes.MarketItem memory) {
        uint256 currentTokenId = _tokenIds.current();
        return idToListedToken[currentTokenId];
    }

    function getListedItemForId(uint256 tokenId) public view returns (DataTypes.MarketItem memory) {
        return idToListedToken[tokenId];
    }

    function getCurrentToken() public view returns (uint256) {
        return _tokenIds.current();
    }
}