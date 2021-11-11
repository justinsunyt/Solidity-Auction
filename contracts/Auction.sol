// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction {
    IERC721 public immutable nft;
    uint256 public immutable nftId;
    address payable public immutable owner;
    address public topBidder;
    uint256 public immutable startPrice;
    uint256 public currentPrice;
    uint256 public endTime;
    
    constructor(IERC721 _nft, uint256 _nftId, uint256 _startPrice, uint256 daysFromNow) {
        require(_startPrice > 1, "Start price should be greater than 1");
        nft = IERC721(_nft);
        nftId = _nftId;
        owner = payable(msg.sender);
        startPrice = _startPrice;
        currentPrice = _startPrice;
        endTime = block.timestamp + (daysFromNow * 1 days);
    }
    
    modifier beforeEnd() {
        require(block.timestamp < endTime, "This auction has ended");
        _;
    }
    
    modifier afterEnd() {
        require(block.timestamp > endTime, "This auction has ended");
        _;
    }
    
    function bid(address bidder, uint256 price) public beforeEnd {
        require(price > currentPrice, "The price is lower than the current price");
        topBidder = bidder;
        currentPrice = price;
    }
    
    function end() public payable afterEnd {
        nft.approve(topBidder, nftId);
        nft.safeTransferFrom(owner, topBidder, nftId);
        owner.transfer(msg.value);
    }
}