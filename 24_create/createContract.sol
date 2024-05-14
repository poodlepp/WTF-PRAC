// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 24 合约中创建新合约
 * uniswap 利用 factory 创建无数pair
 * 
 * Contract x = new Contract{value: _value}(params)
 * 构造函数是payable，才需要传入value
 * 
 * 极简uniswap
 * 
 */

contract Pair {
    address public factory;
    address public token0;
    address public token1;

    constructor() payable {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }

}

//todo