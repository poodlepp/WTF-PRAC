// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 允许一个合约包含多个同质化，非同质化代币
 * GameFi中使用较多
 * 
 * IERC165
 * IERC1155 is IERC165
 * IERC1155Receiver
 * IERC1155MetadataURI
 * ERC1155.sol
 * 
 * WTF里面只是一个简版1155，实际有很多优化点；
 * 不过主体结构是一样的，不同的id代表不同的币；
 * ERC20在一个id内给不同的account计数
 * ERC721会占用很多不同的id，但实际上只会有一个token
 */

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/interfaces/IERC165.sol";

interface IERC1155MetadataURI is IERC1155 {
    function uri(uint256 id) external view returns (string memory);
}

// interface IERC1155 is IERC165 {
//     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
// }
contract Erc1155 {

}