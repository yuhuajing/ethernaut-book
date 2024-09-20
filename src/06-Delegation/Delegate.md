# Delegate
## Reference
[Delegate](https://ethernaut.openzeppelin.com/level/6)

[Delegate.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/06-Delegation/Delegation.sol)

## 目标
1. 成为合约Owner
2.
## 分析
### DelegateCall
1. 当前合约作为A，`A DelegateCall B`的底层逻辑：
   1. A 把B的合约代码整个复制到A的执行环境中
   2. A收到的`msg.data`按照B合约逻辑执行
   3. A合约的参数会按照B合约函数逻辑进行更新
   4. 注意，A按照B的逻辑更新A合约参数是按照`slot`顺序，和参数名称无关
2. Delagation合约参数的存储顺序
```solidity
    address public owner; //slot0
    Delegate delegate;//slot1
```
3. Delegate逻辑合约参数的存储顺序
```solidity
    address public owner; //slot0
```
4. Delegate逻辑合约用于更新slot0的函数
```solidity
contract Delegate {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender; //更新slot0参数
    }
}
```

## 实现步骤
1. 部署`Delegate`合约，部署 `Delegation`合约
2. `Delegation`合约直接发起交易，`calldata`数据为`pwn()`函数选择器
3. 交易被`delegatecall`到`Delegate`合约，按照函数选择器跳转到`pwn()`函数
4. `Delegation`合约按照 `pwn()`函数更新`slot0`数据，`owner`被更新为 `msg.sender`
