// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract SoFairSupply is ERC1155 {
    uint256 public constant SoFairToken = 0; //Id of the very first token released
    uint256 public constant tokenAmountMinted = 70 * 10**6;

    // No URI specified in the constructor. Must be added here if one is provided
    constructor() ERC1155("") {
        _mint(msg.sender, SoFairToken, tokenAmountMinted, ""); //Tokens are minted on the sender's address
    }
}
