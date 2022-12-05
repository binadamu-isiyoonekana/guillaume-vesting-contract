// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// This contract must be "Approved" in the minting contract in order to release the token
contract SofairRound1Distribution {
    ERC1155 public contractSf; // Address of the ERC115 token minting contract

    uint256 public released = 0;
    address[] public beneficiaries;
    address public owner;

    mapping(address => uint256) shares;
    mapping(address => uint256) payment;

    constructor(address mintingContract) {
        contractSf = ERC1155(mintingContract);
        owner = msg.sender;
    }

    // Getter for the total amount of token released.
    function totalReleased() public view returns (uint256) {
        return released;
    }

    // Getter for the payment done to a specified account
    function paymentDone(address _account) public view returns (uint256) {
        return payment[_account];
    }

    // Add a beneficiary's vesting wallet and relase the amount of token he bought on the wallet
    function addBeneficiary(address _account, uint256 _share) public {
        beneficiaries.push(_account);
        shares[_account] =_share;
        release(_account);
    }

    // Release function to distribute the token
    function release(address _account) private {
        require(payment[_account] < shares[_account], "payment already done"); // It doesn't work if 2 persons have the same address and 2nd one has less token
        payment[_account] = shares[_account];
        released = released + payment[_account];
        contractSf.safeTransferFrom(owner, _account, 0, payment, "");
    }
}
