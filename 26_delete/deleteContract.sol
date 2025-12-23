// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 26 删除合约
 * suicide ->  selfdestruct
 *  
 * 自毁，余额发送给传入的地址
 * 自毁之后， 合约代码存储状态都会移除，合约地址仍然存在，   这已经是旧版特性；

 * 
 * 以太坊坎昆（Cancun）升级中，EIP-6780被纳入升级以实现对Verkle Tree更好的支持。EIP-6780减少了SELFDESTRUCT操作码的功能。根据提案描述，当前SELFDESTRUCT仅会被用来将合约中的ETH转移到指定地址，而原先的删除功能只有在合约创建-自毁这两个操作处在同一笔交易时才能生效。所以目前来说：

    已经部署的合约无法被SELFDESTRUCT了。
    SELFDESTRUCT 只能将合约中的eth转移到指定地址，无法移除合约代码。
    如果要使用原先的SELFDESTRUCT功能，必须在同一笔交易中创建并SELFDESTRUCT。

    同笔交易内，创建+销毁同时发生，仍然可以实现自毁

    注意
    对外提供合约销毁接口时，最好设置为只有合约所有者可以调用，可以使用函数修饰符onlyOwner进行函数声明。
    当合约中有selfdestruct功能时常常会带来安全问题和信任问题，合约中的selfdestruct功能会为攻击者打开攻击向量(例如使用selfdestruct向一个合约频繁转入token进行攻击，这将大大节省了GAS的费用，虽然很少人这么做)，此外，此功能还会降低用户对合约的信心。
 */


contract DeleteContract {
    function deleteContract() external {
        selfdestruct(payable(msg.sender));
    }
}