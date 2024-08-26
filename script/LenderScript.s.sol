// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Lender.sol";
import "../src/Staking.sol";
import "../src/Blee.sol";

import {WETH} from "solady/tokens/WETH.sol";
import {VestingWallet} from "openzeppelin-contracts/contracts/finance/VestingWallet.sol";

contract LenderScript is Script {
    function run() public {
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployer);
        new Lender();
        address blee = address(new Blee());
        address weth = address(new WETH());
        address staking = address(new Staking(blee, weth));

        vm.stopBroadcast();
    }
}
