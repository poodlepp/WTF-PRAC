// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract variableTest {
    /**
     * 08
     * 变量初始值
     *
     * 一般的就不写了
     * boolean string int
     *
     * 需要注意的
     * enum 默认值就是其中第一个元素
     * address   address(0)
     * function  internal  external  都是默认空白
     *
     * mapping 所有元素都是默认值
     * struct 成员都是默认值
     * array 定长数组，元素都是默认值
     *
     * delete 元素     变为初始值
     *
     */

    /**
     * 09
     * 可以节省gas，增加安全性
     *
     * constant
     * 适用于  数值， string, bytes address
     * 必须在声明时初始化，之后不可变
     * bytes constant CONSTANT_BYTES = "BBB";
     *
     * immutable
     * 适用于  数值  address
     * 声明时或者构造函数中初始化
     * uint256 public immutable IMMUTABLE_AA;
     */

    /**
     * 10
     * 控制流
     * if else
     * for
     * while
     * do while
     * 三元
     * break continue
     */

    //注意边界问题
    function insertSort(uint256[] memory a) public pure returns (uint256[] memory) {
        for (uint256 i = 1; i < a.length; i++) {
            for (uint256 j = 0; j < i; j++) {
                if (a[j] <= a[i]) {
                    continue;
                } else {
                    uint256 tmp = a[i];
                    for (uint256 x = i; x > j; x--) {
                        a[x] = a[x - 1];
                    }
                    a[j] = tmp;
                    break;
                }
            }
        }
        return a;
    }

    /**
     * 11
     * 构造函数 修饰器
     * constructor 0.4.22 和现在的语法不同
     *
     * modifier 
     */
    modifier onlyOwner() {
        require(msg.sender == msg.sender);
        _;
    }

    /**
     * 12
     * event  日志的抽象
     * ethers.js 可以通过rpc订阅监听
     * 每个事件大约2000gas， 链上一个变量 >20000gas
     *
     * topics
     * 第一个   事件的签名  keccak256
     * indexed 最多三个 每个256bit; 如果非值类型 会计算keccak-256哈希 然后存储，会有数据丢失
     *
     * data  其他变量
     * event Transfer(address indexed from, address indexed to, uint256 value);
     * emit Transfer(from,to,amount);
     *
     */

    /**
     * 13
     * inheritance 继承
     * virtual并不是一定要被子合约继承  override
     *
     * contract baba  is  yeye
     *
     * function多重继承要保持顺序
     * 一个函数在多个合约中都有，要重写；override(a,b,c)
     *
     * modifier 和方法是一样的，也有virtual  override
     *
     * constructor
     * 1 contract B is A(1)
     * 2 constructor(uint _c) A(_c * _c) {}
     *
     * 调用父合约的函数
     * 1 Yeye.pop()
     * 2 super.pop()  多重继承时 会使用最近的父合约（右边的）（override(a,b,c) 这里的话就是c ）
     * 钻石继承  super.pop 会调用所有父合约function，逆序（右边爸爸 左边爸爸，爷爷。。。）
     */

    /**
     * 14
     * 抽象合约
     * abstract
     * virtual
     * 一般使用override 代表实现/重写；
     * virtual  override 是可以同时使用的，重写父合约，同时允许子合约重写
     *
     * interface 接口
     * external
     * bytes4 选择器，  函数签名
     * 接口id (EIP165) 接口中所有方法abi进行异或等处理后生成的一个id;  用于方便其他人活着合约快捷判断是否实现某方法，提供某功能
     * -- supportsInterface(bytes4 interfaceId)
     * ABI 接口  可以互转
     *
     */

    /**
     * 15
     * 异常
     *
     * error  revert    **推荐**
     * 方便高效，节省gas
     *
     * require
     * 费gas
     *
     * assert
     * 一般用于debug
     * 会把剩余的gas全部消耗
     */
}
