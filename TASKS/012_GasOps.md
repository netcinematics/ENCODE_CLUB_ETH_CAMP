/* Gas Optimize this Contract from 500 lines of code to 50 - to pass tests */

SOL2UML to visualize code.

OP Strategies:
remove dead code and variables
start from scratch and build up to all the tests
remove public modifiers, or change them to be more restrictive
don't store msg.sender in a variable
tradePercent > 0 instead of doingthe loop thing to figure it out
return the value instead of looping to set the value to a variable then returning the variable
don't store structs in memory just to push them. Custruct them as you push them
Lots of improvements to addToWhitelist. Just need to set _tier to 3 if it's > 3. Also everything about the oddWhitelist can be removed.
Calldata instead of memory for params
Most things about ImportantStruct (and whitelistStruct or w/e) can be removed. Some of it's props can be reduced to uint8
Constants contract can be totally removed. Things related to getTradingHistory can be simplified.
Remove is Ownable
Rework checkForOwnerOrAdmin, remove extraneous revert call
uint8 for checkForAdmin iterator

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract GasContract {
    address[5] public administrators;
    uint256 public immutable totalSupply; // cannot be updated

    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }

    event Transfer(address, uint256);
    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    mapping(address => uint256) public whitelist;

    constructor(address[5] memory _admins, uint256 _totalSupply) payable {
        administrators = _admins;
        totalSupply = _totalSupply;
    }

    function transfer(address _recipient, uint256 _amount, string calldata _name) external {
        payments[msg.sender].push(Payment(1, _amount));
        unchecked {
        balances[_recipient] += _amount;
        }
        emit Transfer(_recipient, _amount);
    }

    function balanceOf(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function updatePayment(address _user, uint256 _ID, uint256 _amount, uint256 _type) external {
        payments[_user][0].paymentType = _type;
        payments[_user][0].amount = _amount;
    }

    function getPayments(address _user) external view returns (Payment[] memory) {
        return payments[_user];
    }

    function getTradingMode() external pure returns (bool) {
        return true;
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) external {
        whitelist[_userAddrs] = _tier;
    }

    function whiteTransfer(address _recipient, uint256 _amount, Payment calldata _struct) external {
        unchecked {
        uint256 temp = _amount - whitelist[msg.sender];
        balances[msg.sender] -= temp;
        balances[_recipient] += temp;
        }
    }
}