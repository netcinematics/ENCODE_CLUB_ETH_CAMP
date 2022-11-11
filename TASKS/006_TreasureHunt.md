/* Treasure Hunt 

- search clues through goerli network etherscan, 
- into an html file, up to twitter, 
- back down to this solution to claim the treasure
- from the Treasure Chest Contract INTERFACE
- which was the EMIT of the EVENT to show the claim.

*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

interface ITreasureChest {
    function GetTreasure(address) external;
}

contract ClaimTreasure {
    event TreasureClaimed(string);
	function callTreasureContract() external {
        ITreasureChest(0x18acF9DEB7F9535F4848a286b68C729AAc55697a).GetTreasure(0x971ed3B1D66A445d20e75EdE714e64f00e9cAFF8);
        emit TreasureClaimed("Team0");
	}
}
//string imported wallet = 0x971ed3B1D66A445d20e75EdE714e64f00e9cAFF8
//string team_wallet = '0x97b0658844af9b08ed0e826e30417448400abae2';
// TreasureChest contract: 0x18acF9DEB7F9535F4848a286b68C729AAc55697a

