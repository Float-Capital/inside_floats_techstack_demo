// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../src/HodlWallet.sol";
import "../src/InstantApprovalERC20.sol";

contract HodlWalletTest is Test {
    HodlWallet public hodlWallet;
    InstantApprovalERC20 public coolToken;
    address user1 = address(1);

    function setUp() public {
        hodlWallet = new HodlWallet(30 days);

        changePrank(user1);

        coolToken = new InstantApprovalERC20(
            "Test Token",
            "tTKN",
            address(hodlWallet)
        );
    }

    function testDeposit() public {
        skip(0);

        hodlWallet.depositToken(address(coolToken), 200);

        uint256 contractBalance = coolToken.balanceOf(address(hodlWallet));

        console2.log(contractBalance);
        assertEq(contractBalance, 200);

        (uint256 amount, uint256 timestamp) = hodlWallet.userTokens(
            user1,
            address(coolToken)
        );

        assertEq(amount, 200);
        assertEq(timestamp, block.timestamp);
    }

    function testWithdraw(uint32 timestamp) public {
        testDeposit();
        vm.assume(timestamp >= 30 days);
        skip(timestamp);

        hodlWallet.withdrawToken(address(coolToken), 100);
    }
}
