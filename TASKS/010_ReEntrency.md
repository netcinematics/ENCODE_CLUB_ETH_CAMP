/* Review Reentrancy */

- triggered by fallback of sending eth
- when there is no recive function 
- or to a fallback function
- that recursively calls the same claim... 
- before the previous function call logic finishes
- fix this by decrementing the state before the send.

/*
  Re-entrancy study:

  "It's recommended to stop using .transfer() and .send() and instead use .call()."

// bad
contract Vulnerable {
    function withdraw(uint256 amount) external {
        // This forwards 2300 gas, which may not be enough if the recipient
        // is a contract and gas costs change.
        msg.sender.transfer(amount);
    }
}

// good
contract Fixed {
    function withdraw(uint256 amount) external {
        // This forwards all available gas. Be sure to check the return value!
        (bool success, ) = msg.sender.call.value(amount)("");
        require(success, "Transfer failed.");
    }
}


From REENTRANCY HW LINK: 

https://consensys.github.io/smart-contract-best-practices/development-recommendations/general/external-calls/#dont-use-transfer-or-send

// bad
someAddress.send(55);
someAddress.call.value(55)(""); // this is doubly dangerous, as it will forward all remaining gas and doesn't check for result
someAddress.call.value(100)(bytes4(sha3("deposit()"))); // if deposit throws an exception, the raw call() will only return false and transaction will NOT be reverted

// good
(bool success, ) = someAddress.call.value(55)("");
if(!success) {
    // handle failure code
}

ExternalContract(someAddress).deposit.value(100)();


Too many little things to remember... TBH. 🙂

https://consensys.github.io/smart-contract-best-practices/attacks/reentrancy/

  "Each time we make a transfer of tokens, we should call the this recordPayment
function to record the transfer"

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
        recordPmt(from, to, tokenId);
    }

    function getCCID () public view returns (uint256){
        return _ccID.current();
    }


//RE-ENTRANCY TEST:
    struct Payment {
        uint256 tokenId;
        address receiver;
        address sender;
    }
    mapping(address => Payment[]) public payments;
    function viewPmtRecs(address _user) view public returns(Payment[] memory) { //show payments by user.
        console.log("Show payments by user", _user);
        return payments[_user];
    }

    function recordPmt(address _sender, address _receiver, uint256 _tID) public {
        console.log("Record PMT", _tID);   
        payments[_sender].push(Payment(_tID, _receiver, _sender));
        // emit pmtRecordUpdate(payments[_sender]);
    }


//END RE-ENTRANCY TEST:



}
