// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Dont need to spend gas on this so is before startBroadcast
        // not a real TX, simulate it locally.
        HelperConfig helperConfig = new HelperConfig();

        vm.startBroadcast();

        (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();

        FundMe fundMe = new FundMe(ethUsdPriceFeed);

        vm.stopBroadcast();
        return fundMe;
    }
}
