// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * @title ChainRandom
 * 链上方式 &  链下方式
 */
contract ChainRandom {
    /**
     * 链上方式
     * keccak256() 可以得到看似随机的结果 
     * 简单 不安全  节点可以被人操纵 然后挖出自己想要的NFT
     */


    /**
     * 链下方式
     * chainlink VRF
     * requestRandomness  请求
     * fulfillRandomness  回调
     * 依赖chainlink 在各个network中的节点
     * 
     */
}