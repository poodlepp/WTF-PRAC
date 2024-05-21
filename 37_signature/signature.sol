// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 数字签名ECDSA
 * 
 * 
 * 打包消息  kecaak256  abi.encodePacked  address + tokenid
 * 以太坊签名 kecaak256  abi.encodPacked  ("前缀 signed message"， 打包消息)
 * 钱包签名   personal_sign （ account 以太坊签名 ）
 * 
 * 验证签名
 * 签名 + 消息 -> 恢复公钥   （签名就是最终签名  消息是指以太坊签名的结果）
 * 计算出的公钥 如果与实际公钥相同，则验证通过
 * 
 * 利用签名发放NFT白名单，更加经济，因为完全线下 
 * */