// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 27 abi
 * Application Binary Interface
 * 编码
 * 4个变量
 * abi.encode(***) * 每个参数 填充32bytes 拼接在一起 中间很多0
 * abi.encodePacked(***)   不与合约交互时，可以使用这个 节省空间；比如算hash;根据参数使用最低空间
 * abi.encodeWithSignature("foo(uint256)",234)   前面4个字节放函数选择器 kecaak
 * abi.encodeWithSelector(bytes4(keccak256("foo(uint256,address,string,uint256[2])")), x, addr, name, array);   还是上一个方便
 * 
 * call调用只需要知道selector bytes4 + params  不需要知道函数名
 * 
 * 解码
 * decode  需要注意写对解析的类型
 * 
 * staticcall 只读版本的call，应尽量使用其替代call
 * 
 * 只知道签名，不知道具体方法定义；也可以使用上述方法进行调用的
 */

contract abiDemo {
    uint x = 10;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "0xAA";
    uint[2] array = [5, 6]; 

    function encode() public view returns(bytes memory result) {
        result = abi.encode(x, addr, name, array);
    }

    function encodePacked() public view returns(bytes memory result) {
        result = abi.encodePacked(x, addr, name, array);
    }

    function encodeWithSignature() public view returns(bytes memory result) {
        result = abi.encodeWithSignature("foo(uint256,address,string,uint256[2])", x, addr, name, array);
    }

    function encodeWithSelector() public view returns(bytes memory result) {
        result = abi.encodeWithSelector(bytes4(keccak256("foo(uint256,address,string,uint256[2])")), x, addr, name, array);
    }

    function decode(bytes memory data) public pure returns(uint dx, address daddr, string memory dname, uint[2] memory darray) {
        (dx, daddr, dname, darray) = abi.decode(data, (uint, address, string, uint[2]));
    }
    function decode2(bytes memory data) public pure returns(string memory ss) {
        (ss) = abi.decode(data, (string));
    }
}