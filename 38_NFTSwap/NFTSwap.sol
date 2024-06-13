// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

/**
 * @title NFT 交易市场，无手续费
 * @author
 * @notice
 */
contract NFTSwap {
    /**
     * @events
     * 挂单
     * 交易
     * 撤回
     * 修改价格
     */
    event List(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 price
    );
    event Puschase(
        address indexed buyer,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 price
    );
    event Revoke(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId
    );
    event Update(
        address indexed seller,
        address indexed nftAddr,
        uint256 indexed tokenId,
        uint256 newPrice
    );

    struct Order {
        address owner;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Order)) public NFTList;

    fallback() external payable {}

    receive() external payable {}
}
