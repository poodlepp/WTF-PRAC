// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 将智能合约某些功能锁定一段时间  大大减少项目方rug pull  & 黑客攻击的机会；提升安全性
 * Defi  DAO 大量采用，包括  U你swap  Cpomound
 * 
 * 设定锁定期 管理员设为自己
 * 创建交易 加入时间锁队列
 * 锁定期满，执行交易
 * 后悔了取消交易
 */


/**
 * 提交交易时，记录交易相关的所有信息，（合约，value,data,time等等）
 * 取hash放到mapping中记录
 * 交易到时间才可以执行
 * 超时后，交易取消
 */