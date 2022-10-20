// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;


contract VolcanoCoin {

    uint256 totalSupply = 10000;
    uint256 constant tgt = 1000;
    address immutable owner;
    address dead = 0x000000000000000000000000000000000000dEaD ;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        _;
    }

    event totalSupplyChanged( uint256 );

    function testOwner() external view returns(address){
        if(msg.sender == owner){
            return owner;
        } else {
            return dead;
        }
    }

    function setSupply() onlyOwner public {      
        emit totalSupplyChanged(totalSupply+ tgt);
        totalSupply += tgt;
        // assert()
    }


    function getTotalSupply() public view returns (uint256){
        return totalSupply;
    }
}