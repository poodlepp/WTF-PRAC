// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 26 删除合约
 * suicide ->  selfdestruct
 *  
 * 自毁，余额发送给传入的地址
 * 自毁之后， 合约代码存储状态都会移除，合约地址仍然存在，
 * 合约/交易尝试交互时，会返回长度为0的字节数组
 * 很多时候会给调用人带来误判，因为有人认为会收到异常
 *  
 * 未来的以太坊更新中可能会移除底层opcode,所以现在是废弃状态 但是还可以用
 * 
 * 会带来安全问题 信任问题
 */


contract DeleteContract {
    function deleteContract() external {
        selfdestruct(payable(msg.sender));
    }
}