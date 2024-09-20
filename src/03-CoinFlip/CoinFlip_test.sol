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
contract CoinFlipTest is CoinFlip {
    // Variables used to emulate different accounts
    CoinFlip cf;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'

    function beforeAll() public {
        // Initiate account variables
        cf = new CoinFlip();
    }

    /// For Solidity version greater than 0.6.1
    function winGame() public payable {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        if (lastHash == blockValue) {
            revert();
        }
        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        cf.flip(side);
        Assert.equal(cf.consecutiveWins(), 1, "Win once");
    }
}
