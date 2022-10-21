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
        balances[owner] = totalSupply;  //MAP EXECUTION
    }

    modifier onlyOwner {
        require( (owner == msg.sender) , 'must be owner');
        // revert('broke');
        _;
    }

    event totalSupplyChanged( uint256 );
    event transferEvent( uint256, address );

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

    function transfer( uint256 _amt, address _toaddr) public {
        //TIP: senders address is msg.sender
        //TIP: senders address as parameter would be... send money to self?
        emit transferEvent(_amt,_toaddr);
    }

}