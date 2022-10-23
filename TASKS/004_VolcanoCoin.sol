// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "hardhat/console.sol";

contract VolcanoCoin {

    //MAP DECLARATION
    address owner;                       //TIP: immutable? No!
    uint256 constant tgt = 1000;
    uint256 totalSupply = 10000;
    mapping (address => uint256 ) public balances; //TIP: automated get on map?
    mapping (uint256 => Payment) public payments; //TIP: mapping of PAYMENTS.
    uint numPayments = 0;
    // address dead = 0x000000000000000000000000000000000000dEaD ;

    constructor() {
        console.log("constructing VOLCANOOOO COOOOIN!");
        owner = msg.sender;
        balances[owner] = totalSupply;  //MAP EXECUTION
        console.log("VolcanoCoin is alive!");
    }

    modifier onlyOwner {
        console.log("CheckOwner");
        require( (owner == msg.sender) , "ERROR: must be owner"); //REVERTS
        console.log("ONLYOWNER");
        _;
    }

    struct Payment {
        uint256 amt;
        address toaddr;
        address sender;
    }

    event totalSupplyChanged( uint256 );
    event transferEvent( uint256, address );
    // error NotEnoughFunds(uint amt, uint total);
    error errorOverdraft(uint256 amt, uint256 ttl ); //DECLARATION

    function getOwner() external view returns(address){
        return owner;
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
        // console.log("PRE Overdraft")
        //TIP: CUSTOM ERROR errorOverdraft
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

        //TIP: Update Struct... tricky
        payments[++numPayments] = Payment({amt: _amt, toaddr: _toaddr, sender: msg.sender});
    }


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

// TRICKY SYNTAX TO INIT A STRUCT
// Funder(msg.sender, msg.value) to initialise.
//         c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});


}
