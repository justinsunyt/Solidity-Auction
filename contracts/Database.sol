// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "/contracts/Auction.sol";

contract Database {
    Auction[] activeAuctions;
    Auction[] pastAuctions;
    address[] winners;
    
    function createAuction(Auction auction) public {
        require(activeAuctions.length < 30, "There are already 30 active auctions");
        activeAuctions.push(auction);
    }
    
    function endAuction(Auction auction) public {
        uint256 i = 0;
        while (activeAuctions[i] != auction) {
            i++;
        }
        while (i < activeAuctions.length - 1) {
            activeAuctions[i] = activeAuctions[i + 1];
            i++;
        }
        activeAuctions.pop();
        pastAuctions.push(auction);
    }
}