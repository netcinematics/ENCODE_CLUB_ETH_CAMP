// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "hardhat/console.sol";

contract VolcanoCoin {

    //MAP DECLARATION
    mapping (address => uint256 ) public balances; //TIP: automated get on map?
    uint256 constant tgt = 1000;
    uint256 totalSupply = 10000;
    address owner;                       //TIP: immutable? No!
    // address dead = 0x000000000000000000000000000000000000dEaD ;

    constructor() {
        console.log("constructing VOLCANOOOO COOOOIN!");
        owner = msg.sender;
        balances[owner] = totalSupply;  //MAP EXECUTION
        console.log("VolcanoCoin is alive!");
    }

    modifier onlyOwner {
        console.log("ONLYOWNER");
        require( (owner == msg.sender) , 'must be owner');
        // revert('broke');
        _;
    }

    struct Payment {
        uint256 amt;
        address toaddr;
    }

    //TIP: map of user address to array of Payment structs
    mapping (address => Payment) public userPayments;

    event totalSupplyChanged( uint256 );
    event transferEvent( uint256, address );

    function getOwner() external view returns(address){
        return owner;
    }

    function setSupply() onlyOwner public {
        console.log("SETSUPPLY"," should be only owner!"); 
        uint256 checkNum = totalSupply + tgt;     
        emit totalSupplyChanged(checkNum);
        totalSupply += tgt;
        assert(totalSupply!=checkNum);
        if(totalSupply!=checkNum){ 
            revert('Something wrong');
        }
    }

    function getTotalSupply() public view returns (uint256){
        return totalSupply;
    }

    function transfer( uint256 _amt, address _toaddr) public {
        console.log("TRANSFER"," emit event and add coin to addr if found, else add"); 
        assert(_amt>0);
        console.log("PRE SEND SELF check",_toaddr,msg.sender,_toaddr != msg.sender);
        assert(_toaddr != msg.sender); //ERROR: SEND TO SELF, auto error and revert.
        // console.log("PRE Overdraft")
        // assert(_amt>totalSupply-_amt); //ERROR: OVERDRAWN SUPPLY
        // Payment(_amt,_toaddr);
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
    }

    // function seePayments() public view returns (Payment){
    //     return Payment;
    // }

    //TEST-SCRIPT:
    //getTotalSupply = 10,000 ? TRUE
    //getOwner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 ? TRUE
    //balances: mapping to address = 10,000 ? TRUE
    //transfer: ERROR: PAY SELF, LOG and REVERT ? TRUE
    //transfer: PAY NEW ADDR 0xdead ? TRUE
    //transfer: PAY EXISTING 0xdead ? TRUE
    //setSupply: ERROR: NON OWNER: assert/revert ?
    //setSupply: EVENT: totalSupplyChanged ?
    //setSupply: by OWNER: onlyOwner ?
    //setPayments: from transfer
    //seePayments: fn

    //console.log: ? TRUE
    //event: ? TRUE
    //require: ? FALSE
    //revert: ? TRUE
    //assert: ? TRUE
    //customerror: ? FALSE

    //SEARCH for EXAMPLES of this in DOCS... (after struggle) : )

}