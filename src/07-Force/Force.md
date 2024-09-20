# Force

## Reference
[Force](https://ethernaut.openzeppelin.com/level/7)

[Force.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/07-Force/Force.sol)

[SeleDestruct](https://www.evm.codes/#ff?fork=cancun)

## 目标
1. 让Force合约大于0

## 分析
1. 合约作为空合约
   1. 没有`payable`修饰的`constructor`构造函数，无法在合约部署过程中发送余额
   2. 合约没有`receive()/payable`修饰的`fallback()`函数，无法正常接收余额
2. 强制销毁当前合约并强制转账当前合约余额的字节码：`selfdestruct`
```solidity
selfdestruct(_addr); // 销毁当前合约并将当前合约余额发送到提供的地址
```
## 销毁合约
```solidity
contract destroyRobot {
    constructor() payable {}

    function killself(Force force) public {
        selfdestruct(payable(address(force)));
    }

    receive() external payable {}
}
```
1. 允许在合约部署过程以及征程接收`Ether`
2. 定义`killself`函数，实现自毁并强制转移资产

## 实现步骤
1. 、编译部署`Force`合约，部署 `destroyRobot`合约
2. `Force` 合约 余额为0
3. `destroyRobot`余额为0。
4. 转账任意Ether到`destroyRobot`合约，`destroyRobot`余额不为0
5. 执行 `destroyRobot`合约的`killself()`函数注册销毁，并将余额全部转到 `Force`合约
6. `Force`合约强制接收 `destroyRobot`的余额
