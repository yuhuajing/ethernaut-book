// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.00 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol";

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/Fallout.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
/// Inherit 'LunchVenue' contract
contract FalloutTest is Fallback {
    // Variables used to emulate different accounts
    address acc0;
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'

    function beforeAll() public {
        // Initiate account variables
        acc0 = TestsAccounts.getAccount(0);
    }

    /// For Solidity version greater than 0.6.1
    /// #value: 200
    function addValueOnce() public payable {
        Assert.equal(this.owner(), acc0, "owner should be acc0");
        // check if value is same as provided through devdoc
        Assert.equal(msg.value, 200, "value should be 200");

        // execute 'addValue'
        this.contribute{gas: 40000, value: 200}(); // introduced in Solidity version 0.6.2
        address(this).call{gas: 40000, value: 200}("");
        Assert.equal(this.owner(), address(this), "owner should be address(this)");
    }
}
