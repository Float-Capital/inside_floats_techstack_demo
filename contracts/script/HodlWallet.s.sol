// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/HodlWallet.sol";
import "../src/InstantApprovalERC20.sol";

contract HodlWalletScript is Script {
    uint256 lockupTime = 60;

    function run() public {
        vm.startBroadcast();

        //  hodlWalletAddress = new HodlWallet(lockupTime);
        address hodlWalletAddress = address(new HodlWallet(lockupTime));

        console2.log("HodlWallet address: ", hodlWalletAddress);

        // new InstantApprovalERC20(address(1), "Test Token", "tTKN")
        address tokenAddress = address(
            new InstantApprovalERC20("Test Token", "tTKN", hodlWalletAddress)
        );

        console2.log("token address: ", tokenAddress);

        vm.stopBroadcast();
    }
}
