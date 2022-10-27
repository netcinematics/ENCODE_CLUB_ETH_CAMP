/********************************

INSTRUCTIONS: 

1. We made a payment mapping, but we havenʼt added all the functionality for it yet.
a. Write a function to view the payment records, specifying the user as an input.
b. What is the difference between doing this and making the mapping public ?

2. For the payments record mapping, 
c. create a function called recordPayment that takes senderAdd, ReceiverAdd, AMT, 

- AMT: as an input, then 

3. Each time we make a transfer of tokens, 
d. we should call the this recordPayment function to record the transfer

//PASTE INTO REMIX...
\**************************************/
// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is Ownable {
    uint256 constant tgt = 1000;
    uint256 totalSupply = 10000;
    mapping (address => uint256 ) public balances; //TIP: automated get on map?
    // mapping (uint256 => Payment) public payments; //TIP: mapping of PAYMENTS.
    mapping(address => Payment[]) public payments;
    // uint numPayments = 0; //AUDIT: what does this do?
    // address dead = 0x000000000000000000000000000000000000dEaD ;

    constructor() {
        console.log("Ownable VOLCANOOOO COOOOIN!");
        balances[msg.sender] = totalSupply;  //MAP EXECUTION
        console.log("VolcanoCoin is alive!");
    }

    struct Payment {
        uint256 amt;
        address receiver;
        address sender;
    }

    event pmtRecordUpdate( Payment[] );
    event totalSupplyChanged( uint256 );
    event transferEvent( uint256, address );
    error errorOverdraft(uint256 amt, uint256 ttl ); //DECLARATION

    function getOwner() external view returns(address){
        return owner();
    }

    function setSupply() onlyOwner public {
        console.log("SETSUPPLY",totalSupply); 
        console.log("TGT",tgt);
        uint256 checkNum = totalSupply + tgt; 
        console.log("TESTNum",checkNum);
        totalSupply += tgt;
        console.log("NewSupply", totalSupply);
        assert(totalSupply==checkNum);
        emit totalSupplyChanged(totalSupply);
    }

    function getTotalSupply() public view returns (uint256){
        return totalSupply;
    }

    function transfer( uint256 _amt, address _toaddr) public {
        console.log("TRANSFER"," emit event and add coin to addr if found, else add"); 
        assert(_amt>0);
        console.log("PRE SEND SELF check",_toaddr,msg.sender,_toaddr != msg.sender);
        assert(_toaddr != msg.sender); //ERROR: SEND TO SELF, auto error and revert.
        if (totalSupply < _amt){ 
            console.log("ERROR: OVERDRAFT");
            revert errorOverdraft(_amt, totalSupply); 
        }
        // address dead = 0x000000000000000000000000000000000000dEaD ;
        if(balances[_toaddr]>0){
            console.log("Pay Existing addr");
            totalSupply -= _amt;
            balances[_toaddr] += _amt; //PAY EXISTING
        } else {
            console.log("Pay new addr");
            totalSupply -= _amt;
            balances[_toaddr] = _amt; //PAY NEW ADDR
        }
        emit transferEvent(_amt,_toaddr);
        recordPmt(msg.sender, _toaddr, _amt);
        // payments[++numPayments] = Payment({amt: _amt, toaddr: _toaddr, sender: msg.sender});
    }

    function viewPmtRecs(address _user) view public returns(Payment[] memory) { //show payments by user.
        console.log("Show payments by user", _user);
        return payments[_user];
    }//QUESTION: diff from public?


    function recordPmt(address _sender, address _receiver, uint256 _amt) public {
        console.log("Record PMT", _amt);
        //creates a new payment record and adds the new record to the userʼs payment record.       
        payments[_sender].push(Payment(_amt, _receiver, _sender));
        // console.log("RECORD ADD",payments[_sender]);
        // payments[++numPayments] = Payment({amt: _amt, toaddr: _toaddr, sender: msg.sender});
        emit pmtRecordUpdate(payments[_sender]);

    }

    //TEST-SCRIPT
    //Transfer acct 1-2 ? TRUE
    //Transfer acct 2-3 ? TRUE
    //TEST: transfer    ? calls recordPayment ? TRUE
    //TEST: recordPmt   ? adds new payment added to user ? TRUE
    //TEST: viewPmtRecs ? shows payments by SENDER 2,3 ? TRUE

    //tuple(uint256,address,address)[]: 
    //400,0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

    //TEST-SCRIPT:
    //getTotalSupply = 10,000 ? TRUE
    //getOwner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 ? TRUE
    //balances: mapping to address = 10,000 ? TRUE
    //transfer: ERROR: PAY SELF, LOG and REVERT ? TRUE
    //transfer: ERROR: overdraft ? TRUE
    //transfer: PAY NEW ADDR 0xdead ? TRUE
    //transfer: PAY EXISTING 0xdead ? TRUE
    //setSupply: ERROR: NON OWNER: assert/revert ? TRUE
    //setSupply: EVENT: totalSupplyChanged ? TRUE
    //setPayments: from transfer ? TRUE
    //seePayments: public ? TRUE


    //console.log: ? TRUE
    //event: ? TRUE
    //modifier ? TRUE //onlyOwner
    //require: ? TRUE //setSupply
    //revert: ? TRUE
    //assert: ? TRUE
    //customerror: ? TRUE: not enough funds
    //Ownable ? TRUE

    // TRICKY SYNTAX TO INIT A STRUCT
    // Funder(msg.sender, msg.value) to initialise.
    //         c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});


}