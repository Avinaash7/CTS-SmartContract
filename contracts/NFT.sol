// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.9;

// OpenZeppelin modules
import "../node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "../node_modules/@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./helpers/Errors.sol";
import "./storage/NFTStorage.sol";


contract NFT is ERC1155,
    NFTStorage
    {

    /// @dev Id for NFTs using Counters
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter internal tokenIds;
    address contractAddress;

  constructor() ERC1155("ipfs://QmeRChz9s7H9fPTK1CAu3ETJpg8tFHKdKMbfPcfaVRpGRa/1.json") {
        contractAddress = 0x601aAF38C9D3EC1d4b378d0E527D2a538a4D9Dff;
    }

    function mintNFT(uint64 _tokenId, uint64 _quantity)
        public
        returns (uint256)
    {
        tokenIds.increment();
        uint256 newItemId = tokenIds.current();
        _mint(msg.sender, _tokenId, _quantity, "");
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }

  
 


    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC1155: invalid token ID");
    }

    function getApproved(uint256 tokenId)
        public
        view
        virtual
        returns (address)
    {
        _requireMinted(tokenId);
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        address owner = ownerOf(tokenId);
        return (spender == owner ||
            isApprovedForAll(owner, spender) ||
            getApproved(tokenId) == spender);
    }

 




}
