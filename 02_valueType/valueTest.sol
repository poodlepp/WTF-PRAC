// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract valueTest {
    //bool
    bool public _bool;


    //int uint uint256
    int public _int = -1;

    uint256 public _num1 = type(uint256).max;
    //溢出  无法部署
    //uint256 public _num2 = _num1 + 1;
    
    /**
     * address 20bytes
     * payable (transfer, send)
     * balance
     */

    /**
     * 定长  byte  bytes8  bytes32  gas消耗少
     * 不定长    引用类型
     * 其实还是数组
     */

    /**
     * enum ActionSet { Buy, Hold, Sell}
     * ActionSet action = ActionSet.Buy;
     * 可以uint互换，就是0,1,2,3,4...
     *
     */
}