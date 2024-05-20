// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {IERC20} from "./IERC20.sol";
/**
 * 1 代币空投
 * 2 ETH空投
 */
contract airDropDemo {
    error AirDropDemo__generalError();

    function getSum(uint256[] calldata amounts) internal pure returns (uint256 sum) {
        for(uint8 i = 0; i < amounts.length; i++) {
            sum += amounts[i];
        }
        return sum;
    }

    function drop1(
        address token, 
        address[] calldata addrs, 
        uint256[] calldata amounts
        ) external {
        require(addrs.length == amounts.length, "error");
        IERC20 tt = IERC20(token);
        uint256 sum = getSum(amounts);
        require(tt.balanceOf(address(this)) >= sum, "error");
        for(uint8 i = 0; i < addrs.length; i++){
            tt.transferFrom(msg.sender,addrs[i],amounts[i]);
            //emit
        }

    }

    /// eth 空投 略
    
}