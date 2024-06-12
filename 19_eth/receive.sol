// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract receiveTest{
    /**
     * 19 receive fallback
     * 
     * receive() external payable{}
     * 
     * fallback() external payable{}   
     * 使用fallback接收eth是不推荐的
     * 
     * 匹配优先级
     * 1 函数function(msg.data不为空) + 携带eth  
     *   优先匹配对应payable函数，否则fallback
     * 2 msg.data为空 + 携带eth 
     *   优先receive  其次fallback
     */

    event e1(string msg);

    function makeMoney() external payable {
        emit e1("makeMoney");
    }

    receive() external payable{
        emit e1("receive");
    }

    fallback() external payable{
        emit e1("fallback");
    }

    /**
     * 20 接收ETH
     * 
     * 1 transfer   
     *  to.transfer(amount);  gas限制2300  失败会回滚
     * 2 send
     *  to.send(amount); gas限制2300  不会revert，返回bool，需要额外处理
     * 3 call   **推荐**
     *  to.call{value: amount}("");   
     *  不限制gas
     *  不会revert,返回bool,data
     * 
     * 推荐优先级  call > transfer > send
     */


    /**
     * 21 调用其他合约
     * 1 OtherContract(_Address).setX(x);   address作为入参传入
     * 2 直接传入contract
     *   function callGetX(OtherContract _Address) external view returns(uint x){
     *   x = _Address.getX();
     *   }
     * 3 类似1，多出来单独的变量
     *   OtherContract oc = OtherContract(_Address);
     *   x = oc.getX();
     * 4 携带ETH
     *   OtherContract(otherContract).setX{value: msg.value}(x);
     */


    /**
     * 22 
     * call 是 address 的低级成员函数 返回（bool,data）
     * 推荐使用call发送eth
     * 不推荐使用call 进行函数调用
     * 
     * contract_address.call{value:amount, gas:gas数额}(二进制编码);
     * 
     * 二进制编码
     * abi.encodeWithSignature("签名"，参数)
     * abi.encodeWithSignature("ff(uint256)"，参数)
     * 
     * 返回data可以用abi.decode 解码
     * 
     * 有时函数不匹配，fallback处理后也会返回true
     * 
     * 不需要知道源代码即可调用，很有用，很危险
     */


    /**
     * 23 
     * delegateCall
     * address 的低级成员函数 委托call
     * 
     * delegateCall 语法基本一致,语境一直保留在调用合约
     * 可以指定gas  不可以指定eth amount
     * 
     * 使用场景：
     * 代理合约
     * 钻石 EIP2535 Diamonds，没有详细了解
     * 
     * 修改的事固定的slot，而不是去匹配变量名称
     * 有安全隐患
     */
}