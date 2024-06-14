// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 延迟承诺所有权
 * 归属期内匀速释放 
 * 
 * 制定归属规则，时间，金额，人
 * ERC20转账
 * release 线性归属
 */
contract VestingWallet {
    event AddRule(address indexed addr, uint256 amount, uint256 start, uint256 duration);

    struct rule{
        uint256 _amount;
        uint256 _start;
        uint256 _duration;
    }
    mapping(address => rule) balances;
    mapping(address => uint256) released;
    constructor() {}

    function addRule(address _addr, uint256 _amount, uint256 _start, uint256 _duration) public payable {
        require(msg.value >= _amount, "Not enough ether");
        require(_addr!= address(0), "Invalid address");
        balances[_addr] = rule(_amount, _start, _duration);
        emit AddRule(_addr, _amount, _start, _duration);
    }

    function release() public {
        rule storage r = balances[msg.sender];
        require(r._amount > 0, "No rule");
        uint256 releaseAmount = r._amount * (block.timestamp - r._start) / r._duration;
        if(releaseAmount > r._amount) {
            releaseAmount = r._amount;
        }
        releaseAmount = releaseAmount - released[msg.sender];
        require(releaseAmount > 0, "Not yet release");
        released[msg.sender] += releaseAmount;
        (bool success, ) = msg.sender.call{value: releaseAmount}("");
        require(success, "Transfer failed");
    }
}