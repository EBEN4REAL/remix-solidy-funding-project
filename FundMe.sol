// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    uint256 public amountInDollars;
    using PriceConverter for uint256;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    // To improve performance use constant as it is much cheaper to read constant variables and lesser gas is used
    uint256 public constant MINIMUM_USD = 5 * 1e18;
    address public immutable i_owner; // immutable allows variables to be set only once during the initial contract deployment

    constructor() {
        i_owner = msg.sender;
    }

    // payable is a modifier used to indicate that a function (or an address) is capable of receiving Ether.
    function fund() public payable {
        // msg.value holds the amount of Ether (in wei) sent to the function by the caller.
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough ETH"); // 1e18 = 1 ETH = 100000000000000000
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder =  funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // Create the array with 0 elements (i.e., an empty array).
        funders = new address[](0);

        // To send Ether, you need to explicitly mark the address as payable.
        // This converts msg.sender into a payable address, so you can send ETH to it.
        payable(msg.sender).transfer(address(this).balance);
        // send returns a boolean if te funds were sent successfully or not
        // bool isSent = payable(msg.sender).send(address(this).balance);
        // require(isSent, "Send failed");

        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    // use modifiers to avoid using the same `require(msg.sender == owner, "Sender is not the owner!")` everywhere 
    modifier  onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not the owner!");
        // this underscore below says it should proceed to execute the remaining code in whichever function where this modifier is used
        // The order of these matter
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

     receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
