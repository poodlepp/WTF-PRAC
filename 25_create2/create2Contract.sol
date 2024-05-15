// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 25 create2
 * 合约部署之前就能预测地址
 * uniswap使用的就是create2
 * 
 * 0xFF 常数
 * 创建者地址
 * salt 创建者给定的数值
 * bytecode合约字节码
 * 
 * address = hash("0xFF", 创建者地址，salt， bytecode)
 * 
 * 使用场景
 * 1 交易所为用户预留合约地址
 * 2 减少远程调用 
 * 是一些layer2的基础
 */

contract Pair{
    address public factory; // 工厂合约地址
    address public token0; // 代币1
    address public token1; // 代币2

    constructor() payable {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}

contract PairFactory2{
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    function createPair2(address tokenA, address tokenB) external returns (address pairAddr) {
        require(tokenA != tokenB, 'IDENTICAL_ADDRESS');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); 
        bytes32 salt = keccak256(abi.encodePacked(token0,token1));
        Pair pair = new Pair{salt: salt}();
        pair.initialize(tokenA, tokenB);
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}



contract addrCalculate {
        // 提前计算pair合约地址
        function calculateAddr(address tokenA, address tokenB) public view returns(address predictedAddress){
            require(tokenA != tokenB, 'IDENTICAL_ADDRESSES'); //避免tokenA和tokenB相同产生的冲突
            // 计算用tokenA和tokenB地址计算salt
            (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); //将tokenA和tokenB按大小排序
            bytes32 salt = keccak256(abi.encodePacked(token0, token1));
            // 计算合约地址方法 hash()
            predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(type(Pair).creationCode)
            )))));
        }
}
