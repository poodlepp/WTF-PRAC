// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MCERC20 is ERC20{
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_){}

    function mint(address to, uint amount) external {
        _mint(to, amount);
    }
}

contract Multicall {
    // Call结构体，包含目标合约target，是否允许调用失败allowFailure，和call data
    struct Call {
        address target;
        bool allowFailure;
        bytes callData;
    }

    // Result结构体，包含调用是否成功和return data
    struct Result {
        bool success;
        bytes returnData;
    }

    /// @notice 将多个调用（支持不同合约/不同方法/不同参数）合并到一次调用
    /// @param calls Call结构体组成的数组
    /// @return returnData Result结构体组成的数组
    function multicall(Call[] calldata calls) public returns (Result[] memory returnData) {
        uint256 length = calls.length;
        returnData = new Result[](length);
        Call calldata calli;
        
        // 在循环中依次调用
        for (uint256 i = 0; i < length; i++) {
            Result memory result = returnData[i];
            calli = calls[i];
            (result.success, result.returnData) = calli.target.call(calli.callData);
            // 如果 calli.allowFailure 和 result.success 均为 false，则 revert
            if (!(calli.allowFailure || result.success)){
                revert("Multicall: call failed");
            }
        }
    }
}

/**
 * @title 封装multicall  参数 demo
 * gpt 生成，未仔细检查
 */
contract Demo {
    address public MulticallAddress = 0x8fDc9B4a044971313D5D33c4f7623777f7063B73; // Multicall 合约地址
    address public contractAAddress = 0x0000000000000000000000000000000000000001; // 合约 A 地址
    address public contractBAddress = 0x0000000000000000000000000000000000000002; // 合约 B 地址

    function getBalancesAndSymbols(address account) public view returns (uint256 balance, string memory symbol) {
        // 构造 Call 结构体
        Call[] memory calls = new Call[](2);
        calls[0] = Call(contractAAddress, false, abi.encodeWithSignature("balanceOf(address)", account));
        calls[1] = Call(contractBAddress, false, abi.encodeWithSignature("symbol()"));

        // 调用 Multicall 合约的 multicall 函数
        Result[] memory results = Multicall(MulticallAddress).multicall(calls);

        // 解析结果
        if (results[0].success) {
            balance = abi.decode(results[0].returnData, (uint256));
        }
        if (results[1].success) {
            symbol = abi.decode(results[1].returnData, (string));
        }

        return (balance, symbol);
    }
}
