//SPDX-License-Identifier: undefined
pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/console2.sol";

contract HodlWallet {
    uint256 public lockUpTime;

    constructor(uint256 _lockUpTime) {
        lockUpTime = _lockUpTime;
    }

    struct DepositedToken {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => mapping(address => DepositedToken)) public userTokens;

    event Deposit(
        uint256 amount,
        uint256 timestamp,
        address user,
        address token
    );

    event Withdraw(
        uint256 amount,
        uint256 timestamp,
        address user,
        address token
    );

    function depositToken(address _tokenAddress, uint256 _tokenAmount) public {
        IERC20(_tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokenAmount
        );

        uint256 totalAmount = userTokens[msg.sender][_tokenAddress].amount +
            _tokenAmount;

        userTokens[msg.sender][_tokenAddress] = DepositedToken({
            amount: totalAmount,
            timestamp: block.timestamp
        });

        emit Deposit(_tokenAmount, block.timestamp, msg.sender, _tokenAddress);
    }

    function withdrawToken(address _tokenAddress, uint256 _tokenAmount) public {
        DepositedToken storage availableToken = userTokens[msg.sender][
            _tokenAddress
        ];

        require(availableToken.amount >= _tokenAmount, "Insufficient Balance");

        require(
            block.timestamp - availableToken.timestamp >= lockUpTime,
            "Too soon to withdraw your funds"
        );

        IERC20(_tokenAddress).transfer(msg.sender, _tokenAmount);

        userTokens[msg.sender][_tokenAddress] = DepositedToken({
            amount: userTokens[msg.sender][_tokenAddress].amount - _tokenAmount,
            timestamp: userTokens[msg.sender][_tokenAddress].timestamp
        });
        emit Withdraw(_tokenAmount, block.timestamp, msg.sender, _tokenAddress);
    }
}
