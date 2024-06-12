// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract storageTest {

    /**
     * 05
     * reference Type: array  struct mapping
     * storage 
     * memory  
     * calldata  内存中，不上链，immutable，一般用于函数入参
     * 
     * 变量赋值
     * storage - storage   创建引用，共享storage
     * storage - memory    独立副本
     * 
     * 
     * 作用域
     * state variable  默认都是storage
     * local variable
     * global variable (msg.sender, block.number, msg.data)
     */


    /**
     * 06
     * 引用类型
     * array 
     * 固定长度 uint[8]  bytes1[5] address[100]
     * 动态数组 uint[]   bytes1[]  address[]  bytes
     *
     * 创建数组
     * uint[] memory x = new uint[](3);
     * uint[] memory x = new uint[3];
     * 
     * 
     * 单字节数组   bytes 或者 bytes1[]  前者更推荐
     * memory中 bytes1[]会有填充的浪费  31字节填充
     * storage中 不会有字节填充
     * 
     * 动态数组 & bytes
     * push() 最后添加0元素 
     * push(x) 
     * pop() 移除最后一个元素
     */

    /**
     * struct Student {
     *  uint256 id;
     * }
     */


    /**
     * 07
     * mapping(uint => address) public aaa;
     * storage
     * 不能用于入参 出参
     * 没有length 不存储真实的key，只是根据keccak256取数
     * 默认值就是0
     */

}