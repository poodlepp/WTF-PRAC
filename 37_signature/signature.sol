// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 数字签名ECDSA
 * 
 * 
 * 打包消息  kecaak256  abi.encodePacked  address + tokenid
 * 以太坊签名 kecaak256  abi.encodePacked  ("前缀 \x19Ethereum Signed Message:\n32"， 打包消息hash)
 * 钱包签名   personal_sign （ account账户，, 以太坊签名 ）
 * 
 * 验证签名
 * 签名 + 消息 -> 恢复公钥   （签名就是最终签名  消息是指以太坊签名的结果）
 * 计算出的公钥 如果与实际公钥相同，则验证通过
 * 有库可以服用  ECDSA.verify
 * 
 * 利用签名发放NFT白名单，更加经济，因为完全线下
 * 需要中心化接口获取签名，牺牲一部分去中心化
 * 如果用于白名单场景，可以动态变化，这个是优势 
 * */