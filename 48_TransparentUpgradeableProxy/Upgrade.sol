// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * selector   bytes4(keccak256("mint(address)"))
 * 解决方案
 * 1 transparentProxy
 *  admin 只可以调用upgrade
 *  普通用户只能调用logic
 *  如果有冲突 会失败，但是不会错
 *  费gas
 * 
 * 
 * 2 UUPS
 * universal upgradeable proxy standard 
 * 升级函数放在逻辑合约
 * 更复杂
 * 
 * 不会有函数冲突的问题，因为函数都在逻辑里面了，proxy没有不同的函数
 * 
 * 代理合约还是差不多
 * 逻辑合约中也包含 upgrade函数
 */


/**
 * 有一个模糊的点
 * 
 * 逻辑合约的构造函数是没用的，数据不会存到逻辑合约
 */

