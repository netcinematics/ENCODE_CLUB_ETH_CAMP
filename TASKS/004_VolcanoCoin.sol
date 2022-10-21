// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;


contract VolcanoCoin {

    //MAP DECLARATION
    mapping (address => uint256 ) public balances; //TIP: automated get on map?
    uint256 constant tgt = 1000;
    uint256 totalSupply = 10000;
    address owner;                       //TIP: immutable? No!
    // address dead = 0x000000000000000000000000000000000000dEaD ;

    constructor() {
        owner = msg.sender;
        balances[msg.sender] = totalSupply;  //MAP EXECUTION
    }

    modifier onlyOwner {
        // require(owner == msg.sender,”must be owner”);
        _;
    }

    event totalSupplyChanged( uint256 );

    function getOwner() external view returns(address){
        return owner;
    }

    function setSupply() onlyOwner public { 
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
}