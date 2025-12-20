// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract reloadTest {
    /**
     * 16 重载
     * function重载  是不同的selector
     * （如果uint8  uint256  有时是无法区分的，就会报错）
     * 
     * modifier 不可以重载
     */

    /**
     * 17
     * Library
     * 不存在状态变量
     * 不能继承或者被继承
     * 不能接受以太币
     * 不可以被销毁
     * 
     * 使用方法
     * using Strings for uint256;
     * Strings.toHexString(_number);
     * 
     * 常用库
     * string
     * address
     * create2
     * arrays
     * 
     * 特点	       Internal 库函数	        Public / External 库函数
     *   部署方式	嵌入主合约，无需单独部署	必须单独部署，有独立地址
     *   调用方式	JUMP (内部跳转)	DELEGATECALL (外部调用)
     *   Gas 消耗	较低（没有调用开销）	较高（有跨合约开销）
     *   存储参数	可以直接传递 storage 指针	必须通过复杂指令定位存储
     */

    /**
     * 18 import

     * // 通过文件相对位置import
        import './Yeye.sol';
        // 通过`全局符号`导入特定的合约
        import {Yeye} from './Yeye.sol';
        // 通过网址引用
        import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol';
        // npm  引用OpenZeppelin合约
        import '@openzeppelin/contracts/access/Ownable.sol';
     */
}