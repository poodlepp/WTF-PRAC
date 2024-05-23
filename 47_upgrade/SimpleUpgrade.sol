// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

//选择器冲突

contract SimpleUpgrade {
    address public implementation;
    address public admin;
    string public words;

    constructor(address _implementation){
        admin = msg.sender;
        implementation = _implementation;
    }

    /**
     * 此种方法大体与46相同
     * 不是内联汇编，是高级用法
     * 功能受限，灵活性低
     */
    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
    }

    receive() external payable {}

    function upgrade(address newImplementation) external {
        require(msg.sender == admin);
        implementation = newImplementation;
    }

}