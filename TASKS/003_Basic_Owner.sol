// SPDX-License-Identifier: None

pragma solidity 0.8.17;


contract BootcampContract {

    uint256 number;
    //TODO  add variable address of deployer, and contructor setting it, and external function to
    // return 0x00...dEaD. if called by deployer, else if not owner return deployers address.

    function store(uint256 num) public {
        number = num;
    }


    function retrieve() public view returns (uint256){
        return number;
    }
}