// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract NFTStorage {

    mapping(uint256 => address) internal _owners;
  

    /// @dev Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    /// @dev Mapping from token ID to approved address
    mapping(uint256 => address) internal _tokenApprovals;
}