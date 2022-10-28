// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
//PASTE INTO REMIX
import "remix_accounts.sol";
import "../VolcanoCoin4_tests.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    VolcanoCoin vCoin;
    /// 'beforeAll' special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        vCoin = new VolcanoCoin();
    }

    function checkInitBalance() public {
        Assert.equal(vCoin.totalSupply(), 10000, "Init Supply should be 10000");
    }

    function checkSupplyIncrease() public {
        vCoin.setSupply();
        Assert.equal(vCoin.getTotalSupply() ,11000,"New Supply should be 11000");
    }

    /// #sender: account-2
    /// #value: 10
    function checkNonOwnerIncrease() public {
        Assert.equal(vCoin.totalSupply(), 11000, "Not Owner - no change - 11000");
    }

    function checkSuccess() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.ok(2 == 2, 'should be true');
        Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
        Assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
    }

    function checkSuccess2() public pure returns (bool) {
        // Use the return value (true or false) to test the contract
        return true;
    }
    
    function checkFailure() public {
        Assert.notEqual(uint(1), uint(11), "1 should not be equal to 1");
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }
}
    