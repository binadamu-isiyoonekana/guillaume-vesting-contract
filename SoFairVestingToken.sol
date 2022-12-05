// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract SoFairVestingWallet is ERC1155Holder {
    ERC115 public contractSf;
    uint256 immutable _cliff = 3600 * 24 * 365 * 2; // Cliff duration in seconds (2 years)
    uint256 immutable _vesting = 3600 * 24 * 365; // Vesting duration in seconds (1 year)
    uint256 _start; // Start timestamp

    uint256 _tokenReleased = 0;
    address _beneficiary;

    constructor(address beneficiaryAddress, uint256 startTimestamp, address mintingContract)
    {
        require(beneficiaryAddress != address(0), "The beneficiary's address cannot be 0");
        require(mintingContract != address(0), "the minting contract address cannot be 0" );

        contractSf = ERC1155(mintingContract);
        _beneficiary = beneficiaryAddress;
        _start = startTimestamp;
    }

    // Getter for the beneficiary
    function getBeneficiary() public view returns (address) {
        return _beneficiary;
    }

    // Getter for the start timestamp
    function start() public view returns (uint256) {
        return _start;
    }

    // Getter for the vesting duration
    function durationTime() public pure returns (uint256) {
        return (_vesting + _cliff);
    }

    // Getter for the SoFair token already released
    function released() public view returns (uint256) {
        return _tokenReleased;
    }

    // Getter for the amount of the initial share of SoFair IERC1155 token. Absolute number not a percentage
    function _share() public view returns (uint256) {
        return (contractSf.balanceOf(address(this), 0) + _tokenReleased);
    }

    // Release function to transfer the token (linear vesting curve). Must be raplaced by the AI driven vesting schedule from Bobby.
    function release() public {
        uint256 payment;
        if (block.timestamp <= (_start + _cliff)) {
            payment = 0;
        } else if (block.timestamp > (_start + _cliff + _vesting)) {
            payment = 0;
        } else {
            // token already vested based on the balance of the smart contract supply
            uint256 vested;
            vested = _share() - contractSf.balanceOf(address(this), 0);
            _tokenReleased = _tokenReleased + vested;
            // payable amount according to the balance of the smart contract
            payment =
                (_share() * (block.timestamp - (_start + _cliff))) /
                _vesting -
                _tokenReleased;
        }
        // Payment
        contractSf.safeTransferFrom(address(this), _beneficiary, 0, payment, "");
    }
}
