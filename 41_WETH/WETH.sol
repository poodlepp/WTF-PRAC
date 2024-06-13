// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 常见的包装原生代币  WETH WBTC WBNB
 * 等比例兑换为ERC20合约的代币
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);

    constructor() ERC20("WETH", "WETH") {

    }

    fallback() external payable {}

    receive() external payable {}

    function deposit() public payable {
        _mint(msg.sender,msg.value);
        emit Deposit(msg.sender,msg.value);
    }

    function withdraw(uint wad) public {
        require(balanceOf(msg.sender) >= wad, "Not enough balance");
        _burn(msg.sender, wad);
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }


}