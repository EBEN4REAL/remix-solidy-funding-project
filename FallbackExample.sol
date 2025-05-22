// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FallbackExample {
    uint256 public result;

    // this receive function gets triggerd anytime we send a transaction to the contract
    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}