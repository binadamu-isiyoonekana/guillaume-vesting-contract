// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract SoFairSupply is ERC1155 {
    uint256 public constant SoFairToken = 0; //Id of the very first token released the 24/12/2022
    uint256 public constant tokenAmountMinted = 70 * 10**6;

    constructor() ERC1155("{id}") {
        _mint(address(this), SoFairToken, tokenAmountMinted, ""); // Token is available at this contract address
    }
}
