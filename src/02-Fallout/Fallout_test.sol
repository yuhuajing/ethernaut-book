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
contract FalloutTest is Fallout {
    // Variables used to emulate different accounts
    address acc0;
    address acc1;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // Initiate account variables
        acc0 = TestsAccounts.getAccount(0);
        acc1 = TestsAccounts.getAccount(1);
    }

    function changeFalloutOwner() public {
        Assert.equal(this.owner(), address(0), "Default to address 0");
        Fal1out();
        Assert.equal(this.owner(), acc0, "Change owner to the msg.sender #acc0");
        this.Fal1out();
        Assert.equal(this.owner(), address(this), "Change owner to the msg.sender #contract");
    }
}
