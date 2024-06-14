// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * 传统的ERC20 只能由用户进行操作，或者先用户授权，其他spender才能操作
 *
 * ERC20Permit 链下签名 用户甚至可以不持有ETH，委托第三方交易
 *
 * IERC20Permit
 * permit
 * nonces
 * DOMAIN_SEPARATOR
 *
 * 
 * 与712相似度极高，DAMAIN_SEPARATOR 是合约init的时候写死的，不用管了；
 * 管好自己的TYPE_HASH
 * 
 * 给用户带来了便利，也带来了风险，一个签名可以带走一切
 */
import "./IERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
    mapping(address => uint) private _nonces;
    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );

    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol) EIP712(name, "1") {}

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual override {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        bytes32 structHash = keccak256(
            abi.encode(
                _PERMIT_TYPEHASH,
                owner,
                spender,
                value,
                _useNonce(owner),
                deadline
            )
        );
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");
        _approve(owner, spender, value);
    }

    function nonces(
        address owner
    ) public view virtual override returns (uint256) {
        return _nonces[owner];
    }

    function DOMAIN_SEPARATOR() external view override returns (bytes32) {
        return _domainSeparatorV4();
    }

    function _useNonce(
        address owner
    ) internal virtual returns (uint256 current) {
        current = _nonces[owner];
        _nonces[owner] += 1;
    }

    function mint(uint amount) external {
        _mint(msg.sender, amount);
    }


}
