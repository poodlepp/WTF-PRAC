// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {IERC20} from "./IERC20.sol";
/**
 * 32 代币水龙头
 * 一个ERC20代币
 * 一个proxy contract 用于法币，调用就发
 * 需要先转账一些币到这个proxy
 */

contract faucetDemo {
    event SendToken(address indexed Receiver, uint256 indexed Amount);

    uint256 public amountAllowed = 100;
    address public tokenContract;
    mapping(address => bool) public requestedAddress;

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function requestToken() external {
        require(requestedAddress[msg.sender] == false, "error!");
        IERC20 token = IERC20(tokenContract);
        require(token.balanceOf(address(this)) >= amountAllowed, "faucet empty");
        token.transfer(msg.sender, amountAllowed);
        requestedAddress[msg.sender] = true;
        emit SendToken(msg.sender, amountAllowed);
    }
}