// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 28
 * 单向
 * 灵敏
 * 高效
 * 均一
 * 抗碰撞
 * 
 * hash = kecaak256(data)
 * 读音 凯 查克
 */

// contract hashDemo {
// }


/**
 * 29 selector
 * msg.data 是完整的calldata
 */

contract selectorTest {

    function test(address aa, uint256 bb, string calldata cc) external returns(string memory) {
        return "123445";
    }
    // 签名计算  大部分类型参数都是直接算；
    // struct也可以算 bytes4(keccak256("mappingParamSelector(address,(uint256,bytes),uint256[],uint8)"));
    function testSelector() external pure returns(bytes4 mSelector) {
        return bytes4(keccak256("test(address,uint256,string)"));
    }

    function callWithSignature(bytes4 sel, address aa, uint256 bb, string calldata cc) external returns (bool, bytes memory) {
        (bool success, bytes memory data) = address(this).call(abi.encodeWithSelector(sel,aa,bb,cc));
        return (success, data);
    }

    function decode(bytes memory data) public pure returns(string memory ss) {
        (ss) = abi.decode(data, (string));
    }
}


/**
 * 30 try catch 
 * 
 * 可以支持external函数调用 、 合约创建
 * this.f() 视为外部函数调用
 * 
 * 函数有返回值  一定要returns
 * 合约创建 返回的就是合约
 * 
 * revert require 使用catch  Error(string memory reason)
 * panic错误 catch Panic(uint errorCode)
 * assert revert()   require(false)   使用catch(bytes memory reason)
 * 
 * 
 */

contract OnlyEven{
    constructor(uint a){
        require(a != 0, "invalid number");
        assert(a != 1);
    }

    function onlyEven(uint256 b) external pure returns(bool success){
        // 输入奇数时revert
        require(b % 2 == 0, "Ups! Reverting");
        success = true;
    }
}


contract TryCatch{
    // 成功event
    event SuccessEvent();

    // 失败event
    event CatchEvent(string message);
    event CatchByte(bytes data);

    // 声明OnlyEven合约变量
    OnlyEven even;

    constructor() {
        even = new OnlyEven(2);
    }

    // 在external call中使用try-catch
    function execute(uint amount) external returns (bool success) {
        try even.onlyEven(amount) returns(bool _success){
            // call成功的情况下
            emit SuccessEvent();
            return _success;
        } catch Error(string memory reason){
            // call不成功的情况下
            emit CatchEvent(reason);
        }
    }

    // 在创建新合约中使用try-catch （合约创建被视为external call）
    // executeNew(0)会失败并释放`CatchEvent`
    // executeNew(1)会失败并释放`CatchByte`
    // executeNew(2)会成功并释放`SuccessEvent`
    function executeNew(uint a) external returns (bool success) {
        try new OnlyEven(a) returns(OnlyEven _even){
            // call成功的情况下
            emit SuccessEvent();
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            // catch失败的 revert() 和 require()
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            // catch失败的 assert()
            emit CatchByte(reason);
        }
    }
}