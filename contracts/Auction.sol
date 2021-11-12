// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Auction {
    IERC721 public nft;
    uint256 public nftId;
    address payable public immutable owner;
    address public topBidder;
    uint256 public startPrice;
    uint256 public currentPrice;
    uint256 public endTime;
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    function configure(IERC721 _nft, uint256 _nftId, uint256 _startPrice, uint256 daysFromNow) public {
        require(_startPrice > 1, "Start price should be greater than 1");
        nft = IERC721(_nft);
        nftId = _nftId;
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
    
    function bid(uint256 price) public beforeEnd {
        require(price > currentPrice, "The price is lower than the current price");
        topBidder = msg.sender;
        currentPrice = price;
    }
    
    function end() public payable afterEnd {
        nft.safeTransferFrom(address(this), topBidder, nftId);
        owner.transfer(currentPrice);
    }
    
    function emergencyEnd() public payable {
        nft.safeTransferFrom(address(this), topBidder, nftId);
        owner.transfer(currentPrice);
    }
}