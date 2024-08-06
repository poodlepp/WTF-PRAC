// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 跨链桥
 * 比如以太坊主网  通过跨链桥转移到其他兼容以太坊的侧链，独立链
 * 跨链需要可信第三方执行
 * 分类
 * burn/mint 需要跨链桥拥有代币的铸造权  适合项目方自己搭建的跨链桥
 * stake/mint  一般使用的方案，不需要权限，风险较大
 * stake/unstake  需要跨链桥在两条链都有锁定的代币，门槛较高
 * 
 * 这个桥的实现很重要，去中心化才有信任
 */


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CrossChainToken is ERC20, Ownable {
    
    // Bridge event
    event Bridge(address indexed user, uint256 amount);
    // Mint event
    event Mint(address indexed to, uint256 amount);

    /**
     * @param name Token Name
     * @param symbol Token Symbol
     * @param totalSupply Token Supply
     */
    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) payable ERC20(name, symbol)
    Ownable(msg.sender) {
        _mint(msg.sender, totalSupply);
    }

    /**
     * Bridge function
     * @param amount: burn amount of token on the current chain and mint on the other chain
     */
    function bridge(uint256 amount) public {
        _burn(msg.sender, amount);
        emit Bridge(msg.sender, amount);
    }

    /**
     * Mint function
     */
    function mint(address to, uint amount) external onlyOwner {
        _mint(to, amount);
        emit Mint(to, amount);
    }
}

