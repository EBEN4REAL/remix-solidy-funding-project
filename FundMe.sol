// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FundMe {
    // payable is a modifier used to indicate that a function (or an address) is capable of receiving Ether.
    function fund() public payable {
        // msg.value holds the amount of Ether (in wei) sent to the function by the caller.
        require(msg.value > 1e18, "Didn't send enough ETH");
    }

    function withdraw() public {

    }
}