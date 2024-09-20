// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.00 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol";

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/Telephone.sol";

// File name has to end with '_test.saol', this file can contain more than one testSuite contracts
/// Inherit 'LunchVenue' contract
contract TelephoneTest is Telephone, AtTelephone {
    // Variables used to emulate different accounts
    AtTelephone attel;
    Telephone tel;
    address acc0;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'

    function beforeAll() public {
        // Initiate account variables
        attel = new AtTelephone();
        tel = new Telephone();
        acc0 = TestsAccounts.getAccount(0);
    }

    /// For Solidity version greater than 0.6.1
    function winGame() public payable {
        Assert.notEqual(tel.owner(), acc0, "Tel owner not the #acc0");
        attel.attack(tel, acc0);
        Assert.equal(tel.owner(), acc0, "Change owner to #acc0");
    }
}
