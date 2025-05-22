// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
      function getPrice() internal view returns(uint256) {
        // get the below address from here; https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // This function below returns a tuple:
        (,int256 price,,,) = priceFeed.latestRoundData();
        // This is destructuring the tuple returned above.
        // 2500.00000000
        return uint256(price) * 1e10; // Now the price is scaled to match 18-decimal precision, so it can be compared or multiplied with ETH values (which are in wei, 1 ETH = 1e18).
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256) {
        // This is a Solidity type cast: you're telling Solidity, 
        // Treat this address as a contract that follows the AggregatorV3Interface interface
        // Seplia testnet ETH/USD address - 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        // ZKSync Seplia testnet ETH/USD address - 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
       return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}