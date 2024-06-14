// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * V神说 多签钱包比硬件钱包更安全
 * Gnosis Safe是以太坊最流行的多签钱包  400亿美金资产
 * 支持多链 丰富的DAPP
 * 合约钱包
 * 
 * 逻辑
 * 多签人 门槛
 * 创建交易
 * 收集多签签名（交易hash让多人签名，并拼接到一起）
 * 多签合约验证签名，执行交易
 */

contract MultisigWallet {
    event ExecutionSuccess(bytes32 txHash);
    event ExecutionFailure(bytes32 txHash);
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public ownerCount; // 多签持有人数量
    uint256 public threshold; // 多签执行门槛
    uint256 public nonce;

    receive() external payable {}

    constructor(address[] memory _owners, uint256 _threshold) {
        _setupOwners(_owners, _threshold);
    }

    /// @dev 初始化owners, isOwner, ownerCount,threshold 
    /// @param _owners: 多签持有人数组
    /// @param _threshold: 多签执行门槛，至少有几个多签人签署了交易
    function _setupOwners(address[] memory _owners, uint256 _threshold) internal {
        // threshold没被初始化过
        require(threshold == 0, "WTF5000");
        // 多签执行门槛 小于 多签人数
        require(_threshold <= _owners.length, "WTF5001");
        // 多签执行门槛至少为1
        require(_threshold >= 1, "WTF5002");

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            // 多签人不能为0地址，本合约地址，不能重复
            require(owner != address(0) && owner != address(this) && !isOwner[owner], "WTF5003");
            owners.push(owner);
            isOwner[owner] = true;
        }
        ownerCount = _owners.length;
        threshold = _threshold;
    }

    function execTransaction(address to, uint256 value, bytes memory data, bytes memory signatures)
        public payable virtual returns (bool success) {
            bytes32 txHash = encodeTransaction(to, value, data, nonce, block.chainid);
            nonce++;
            checkSignatures(txHash, signatures);
            (success,) = to.call{value: value}(data);
            require(success, "WTF5004");
            if (success) emit ExecutionSuccess(txHash);
            else emit ExecutionFailure(txHash);
        }

    // 检查签名   复原出签名者然后核对
    function checkSignatures(bytes32 txHash, bytes memory signatures) public view {
        uint256 _threshold = threshold;
        require(_threshold > 0, "WTF5005");
        require(signatures.length >= _threshold * 65, "WTF5006");
        address lastOwner = address(0);
        address currentOwner;
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 i;
        for ( i = 0; i < _threshold; i++) {
            (v,r,s) = signatureSplit(signatures, i);
            currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", txHash)), v, r, s);
            require(currentOwner > lastOwner && isOwner[currentOwner], "WTF5007");
            lastOwner = currentOwner;
        }
    }

    // 格式化签名
    function signatureSplit(bytes memory signatures, uint256 pos)
        internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        assembly {
            let signaturePos := mul(0x41, pos)
            r := mload(add(signatures, add(signaturePos, 0x20)))
            s := mload(add(signatures, add(signaturePos, 0x40)))
            v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
        }
    }

    function encodeTransaction(address to, uint256 value, bytes memory data, uint256 _nonce, uint256 chainId)
        public pure returns (bytes32) {
            bytes32 safeTxHash = keccak256(abi.encode(to, value, keccak256(data), _nonce, chainId));
            return safeTxHash;
        }
}