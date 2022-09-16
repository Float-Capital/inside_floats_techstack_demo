//SPDX-License-Identifier: undefined
pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract InstantApprovalERC20 is ERC20 {
    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        address _savingsContract
    ) ERC20(_tokenName, _tokenSymbol) {
        _mint(msg.sender, 1000 ether);
        approve(_savingsContract, 1000 ether);
    }
}
