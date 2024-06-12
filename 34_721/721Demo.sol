// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

// import {IERC721} from "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";
/**
 * ERC721
 * EIP 包含 ERC
 * 
 * IERC165  supportsInterface
 * IERC721  balanceOf,ownerOf,safeTransferFrom,transferFrom,approve,setApprovalForAll,getApproved,isApprovedForAll
 * IERC721Receiver   调用方  _checkOnERC721Received
 * IERC721Metadata
 * 
 * 核心的功能就是 mint  burn  transfer  trasnferFrom safe***  approve  approveAll
 * 
 * ERC721仍在发展中  
 * 新的标准有  ERC721Enumerable   ERC721A
 * ERC721A 支持一次交易以极低fee 铸造多个NFT；实际效果明显优于ERC721Enumerable
 * 优化点： 删除重复存储，批量铸造来更新所有者余额&其他数据
 * 
 */

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract NftDemo is IERC165{
    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return 
        interfaceId == type(IERC721).interfaceId ||
        interfaceId == type(IERC165).interfaceId;
    }
}

interface IERC721 is IERC165{
    /**
     *  @dev This emits when ownership of any NFT changes by any mechanism. This includes
     *  minting, burning, and transferring.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    /**
     *  @dev This emits when the approval of a token is changed or reaffirmed.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);


    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function setApprovalForAll(address operator, bool _approved) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function isApprovedForAll(address owner, address operator) external view returns (bool);

}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 {
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (to.isContract()) {
            return IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) == IERC721Receiver.onERC721Received.selector;
        }else {
            return true;
        }
            
    }
}

// IERC721Metadata  name,symbol,tokenURI

