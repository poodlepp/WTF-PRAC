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

    //这里不使用构造函数的考虑是  uniswap使用create2,构造函数不能有参数；create其实是允许构造函数传参的
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "UniswapV2: FORBIDDEN");
        token0 = _token0;
        token1 = _token1;
    }

}

contract PairFactory {
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    function creaePair(address tokenA, address tokenB) external returns (address pairAddr) {
        Pair pair = new Pair();
        pair.initialize(tokenA, tokenB);
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}


