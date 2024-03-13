// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // Creates a address so we control from where the requests are comming from
    address USER = makeAddr("user");

    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 1 ether;

    function setUp() external {
        // fundMe = new FundMe(); // FundMeTest is the one deploying the FundMe contract on a local network
        DeployFundMe deployFundMe = new DeployFundMe(); // msg.sender deploys the FundMe contract that is the one running the script
        fundMe = deployFundMe.run();

        // feeds the created address with value
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughtEth() public {
        vm.expectRevert(); // The next line should revert
        fundMe.fund(); // Sending 0 value
    }

    function testFundUIpdatesFundedDataStructure() public {
        vm.prank(USER); // Next TX will be sent by user address
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}
