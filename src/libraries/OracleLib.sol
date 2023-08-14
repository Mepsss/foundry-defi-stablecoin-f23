//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/*
* @title OracleLib
* @notice This library is meant to be used to check the ChainLink price feeds arent stale
* If they are stale, the function will revert, and render the DSCEngine unusable by design.
* Not optimal, simplified solution.
*/
library OracleLib {
    error OracleLib__STalePrice();

    uint256 private constant TIMEOUT = 3 hours; //3*60*60 = 10800 seconds
    //same returns as ChainLink price feed lastRoundData()

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt; //seconds since pricefeed update
        if (secondsSince > TIMEOUT) revert OracleLib__STalePrice();

        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }
}
