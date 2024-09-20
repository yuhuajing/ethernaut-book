# NaughtCoin

## Reference
[NaughtCoin](https://ethernaut.openzeppelin.com/level/15)

[NaughtCoin.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/15-NaughtCoin/NaughtCoin.sol)

## 目标
1. 将Owner用户的资产在封锁期内转走

## 分析
### transfer()
```solidity
    function transfer(address _to, uint256 _value) public override lockTokens returns (bool) {
        super.transfer(_to, _value);
    }
```
1. 合约 `override` 重写了 `transfer()`函数，不允许 `player`用户在封锁期内转移资产
### approve()
1. `ERC20` 支持授权和 `transferFrom()` 授权转账操作

## 合约设计思路
1. `msg.sender == player`的时候，需要满足 lock 条件
2. 因此，需要 `msg.sender != player`
3. `approval()`授权操作允许 在 2 的基础上同时可以操作 `player` 的资产
4. 因此，部署者只需要将资产授权给第三方地址：第三方地址不满足 `modifier lock`条件，同时可以转账`player`的Token

