/***********************************\
NOTES: This took forever to find good example.
https://docs.openzeppelin.com/contracts/4.x/
$ npm install @openzeppelin/contracts


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

    // function getOwnerOf (uint256 id) public view returns (uint256){
    //     return getOwnerOf
    // }
}

// praaaaaaagma sooooooolidity 0.8.17;

// import "hardhat/console.sol";
// // import "@openzeppelin/contracts/access/Ownable.sol";
// // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// contract VolcanoCoin {
//     uint256 constant tgt = 1000;
//     uint256 public totalSupply = 10000;
//     mapping (address => uint256 ) public balances; //TIP: automated get on map?
//     mapping(address => Payment[]) public payments;
//     // address dead = 0x000000000000000000000000000000000000dEaD ;

//     constructor() {
//         console.log("Ownable VOLCANOOOO COOOOIN!");
//         balances[msg.sender] = totalSupply;  //MAP EXECUTION
//         console.log("VolcanoCoin is alive!");
//     }

//     struct Payment {
//         uint256 amt;
//         address receiver;
//         address sender;
//     }

//     event pmtRecordUpdate( Payment[] );
//     event totalSupplyChanged( uint256 );
//     event transferEvent( uint256, address );
//     error errorOverdraft(uint256 amt, uint256 ttl ); //DECLARATION

//     function getOwner() external pure returns(address){
//         return 0x000000000000000000000000000000000000dEaD;
//     }

//     function setSupply() public {
//         console.log("SETSUPPLY",totalSupply); 
//         console.log("TGT",tgt);
//         uint256 checkNum = totalSupply + tgt; 
//         console.log("TESTNum",checkNum);
//         totalSupply += tgt;
//         console.log("NewSupply", totalSupply);
//         assert(totalSupply==checkNum);
//         emit totalSupplyChanged(totalSupply);
//     }

//     function getTotalSupply() public view returns (uint256){
//         return totalSupply;
//     }

//     function transfer( uint256 _amt, address _toaddr) public {
//         console.log("TRANSFER"," emit event and add coin to addr if found, else add"); 
//         assert(_amt>0);
//         console.log("PRE SEND SELF check",_toaddr,msg.sender,_toaddr != msg.sender);
//         assert(_toaddr != msg.sender); //ERROR: SEND TO SELF, auto error and revert.
//         if (totalSupply < _amt){ 
//             console.log("ERROR: OVERDRAFT");
//             revert errorOverdraft(_amt, totalSupply); 
//         }
//         // address dead = 0x000000000000000000000000000000000000dEaD ;
//         if(balances[_toaddr]>0){
//             console.log("Pay Existing addr");
//             totalSupply -= _amt;
//             balances[_toaddr] += _amt; //PAY EXISTING
//         } else {
//             console.log("Pay new addr");
//             totalSupply -= _amt;
//             balances[_toaddr] = _amt; //PAY NEW ADDR
//         }
//         emit transferEvent(_amt,_toaddr);
//         recordPmt(msg.sender, _toaddr, _amt);
//     }

//     function viewPmtRecs(address _user) view public returns(Payment[] memory) { //show payments by user.
//         console.log("Show payments by user", _user);
//         return payments[_user];
//     }

//     function recordPmt(address _sender, address _receiver, uint256 _amt) public {
//         console.log("Record PMT", _amt);   
//         payments[_sender].push(Payment(_amt, _receiver, _sender));
//         emit pmtRecordUpdate(payments[_sender]);
//     }
