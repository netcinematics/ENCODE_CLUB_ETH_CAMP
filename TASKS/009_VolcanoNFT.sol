/***********************************\
NOTES: This took forever to find good example.
https://docs.openzeppelin.com/contracts/4.x/
$ npm install @openzeppelin/contracts

DEPLOYED goerli:

- deploy: https://goerli.etherscan.io/tx/0x35f13a7ea4bafb985572ee316eda542821cd6c3e3658fdb14b376bebbca15297
- contract: https://goerli.etherscan.io/address/0x96ef46b7d9a2b9ac51d8a989068548c9edac491e

INSTRUCTIONS:
use the Open Zeppelin libraries to help with this.
1. inherit from ERC721Full Open Zeppelin standard libraries
2. Give your NFT a name and a symbol
3. Write unit tests to check that you can
4a. Mint new NFTs
4b. Transfer an NFT
4c. Deploy your contract to Goerli 
4d. send some NFTs to your colleagues.
//PASTE INTO REMIX...
\**************************************/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/security/Pausable.sol";
// import "@openzeppelin/contracts/access/AccessControl.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";

/// @custom:security-contact netcinematics@protonmail.com
contract COZMOCOINZ is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _ccID;
    
    constructor() ERC721("COZMOCOINZ", "COZ") {}

    function mintCOZMOZ (address to) public onlyOwner {
        uint256 tokenId = _ccID.current();
        _ccID.increment();
        console.log("MINT",msg.sender);
        _mint(to, tokenId);
        
        // string memory tokenURI = "https://base";
        // _setTokenURI(ccID, tokenURI);
    }

    function transferCOZMOZ(address from, address to, uint256 tokenId) public {
        _transfer(from, to, tokenId);
    }

    function getCCID () public view returns (uint256){
        return _ccID.current();
    }

}
