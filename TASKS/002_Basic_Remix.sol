// SPDX-License-Identifier: None
// USE F5 in VSCode to compile solidity, with plugin.
pragma solidity 0.8.17;


contract BootcampContract {

    uint256 number;


    function store(uint256 num) public {
        number = num;
    }


    function retrieve() public view returns (uint256){
        return number;
    }
}

 