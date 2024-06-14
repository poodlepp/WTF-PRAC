// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * EIP-712 类型化数据签名
 * 
 * 核心概念DOMAIN_SEPARATOR   STORAGE 
 * 
 * 链下签名  链上验证
 */
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract EIP712 {
    using ECDSA for bytes32;

    bytes32 private constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 private constant STORAGE_TYPEHASH = keccak256("Storage(address spender,uint256 number)");
    bytes32 private DOMAIN_SEPARATOR;
    uint256 number;
    address owner;

    constructor() {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                EIP712DOMAIN_TYPEHASH,
                keccak256(bytes("EIP712")),
                keccak256(bytes("1")),
                1,
                address(this)
            )
        );
        owner = msg.sender;
    }

    function permitStore(uint256 _num, bytes memory _signature) public {
        require(_signature.length == 65, "invalid signature length");
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(_signature, 0x20))
            s := mload(add(_signature, 0x40))
            v := byte(0, mload(add(_signature, 0x60)))
        }

        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(STORAGE_TYPEHASH, msg.sender, _num))
        ));

         address signer = digest.recover(v,r,s);
         require(signer == owner, "EIP712: invalid signature");
         number = _num;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }
}