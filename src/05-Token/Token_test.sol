// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.00 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol";

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/Fallout.sol";

// File name has to end with '_test.saol', this file can contain more than one testSuite contracts
/// Inherit 'LunchVenue' contract
contract TokenTest{
    // Variables used to emulate different accounts
    Token token;
    address acc0;
    address acc1;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'

    function beforeAll() public {
        // Initiate account variables
        token = new Token(123);
        acc0 = TestsAccounts.getAccount(0);
        acc1 = TestsAccounts.getAccount(1);
    }

    /// For Solidity version greater than 0.6.1
    /// #sender: account-1
    function winGame() public {
        token.transfer(acc0, 124);
        Assert.equal(
            token.balanceOf(acc0),
            124,
            "Balance of acc0 should be 1"
        );
        Assert.equal(
            token.balanceOf(address(this)),
            type(uint256).max,
            "Balance of address(this) should be type(uint256).max"
        );
    }
}
