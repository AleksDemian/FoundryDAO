// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {GovToken} from "../src/GovToken.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {Box} from "../src/Box.sol";

contract DeployGovernance is Script {
    uint256 public constant MIN_DELAY = 3600; // 1 hour - after a vote passes
    address[] proposers;
    address[] executors;

    function run() external returns (GovToken, TimeLock, MyGovernor/*, Box*/) {
        vm.startBroadcast();
        GovToken govToken = new GovToken(msg.sender);
        TimeLock timelock = new TimeLock(MIN_DELAY, proposers, executors);
        MyGovernor governor = new MyGovernor(govToken, timelock);
        
        Box box = new Box();
        box.transferOwnership(address(timelock));

        vm.stopBroadcast();
        return (govToken, timelock, governor/*, box*/);
    }
}