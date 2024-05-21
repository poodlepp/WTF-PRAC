// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
/**
 * merkle tree
 * 子节点都是hash值， 两个子节点hash值拼接后再hash，就是父节点
 * 
 * 子节点的value hash +  沿着分支向上，所有相邻的hash  -> root
 *  
 * demo: 利用merkle tree 发放白名单
 * 构造函数传入root
 * mint的时候传入address， proof ,tokenId
 * 使用mintedAddresses 记录是否已经mint，已经mint则不能再次mint
 */

library MerkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computeHash = leaf;
        for (uint i = 0; i < proof.length; i++) {
            computeHash = keccak256(abi.encodePacked(computeHash, proof[i]));
        }
        return computeHash;
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a,b)) : keccak256(abi.encodePacked(b,a));
    }
    
}

contract MerkleTree is ERC721 {
    bytes32 immutable public root;
    mapping(address => bool) public mintedAddresses;

    constructor(string memory name, string memory symbol, bytes32 merkleroot)
    ERC721(name,symbol)
    {
        root = merkleroot;
    }

    function mint(address to, uint256 tokenId, bytes32[] memory proof) external {
        require(!mintedAddresses[to], "Address already minted");
        require(_verify(_leaf(to), proof), "invalid merkle proof");

        mintedAddresses[to] = true;
        _safeMint(to, tokenId);
    }

    function _leaf(address account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account));
    }

    function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
        return MerkleProof.verify(proof,root,leaf);
    }


}