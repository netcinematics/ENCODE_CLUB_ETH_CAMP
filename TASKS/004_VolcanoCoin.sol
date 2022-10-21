// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;


contract VolcanoCoin {

    mapping (address => uint256 ) balances;
    uint256 totalSupply = 10000;
    uint256 constant tgt = 1000;
    address immutable owner;
    address dead = 0x000000000000000000000000000000000000dEaD ;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        // require(owner == msg.sender,”must be owner”);
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