# King

## Reference
[King](https://ethernaut.openzeppelin.com/level/9)

[King.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/09-King/King.sol)

## 目标
1. 让游戏无法进行

## 分析
### transfer()
1. `transfer()/send()`函数，都可以实现资金转移，并且只会传递2300用于转账的gas，避免接收方用剩余gas做额外的操作
2. `transfer()`转账失败的话，整笔交易回滚
3. `send()`转账会返回 `bool` 类型标识，转账失败的话，返回`false`,但是不会回滚交易
4. `call()`转账可以指定gas,返回`bool和data`，并且转账失败的话不会回滚整笔交易

### receive()
```solidity
    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }
```
1. `King` 合约类似庞氏骗局，在场中的会获取新进场的资金
2. `payable(king).transfer(msg.value);`,资金从合约转到 `旧King`
3. Sender成为`新King`,等待别人以更高资金接盘
4. 转账方式采用 `transfer()`,转账失败会导致交易回滚

### 接收资产
1. EOA地址可以接收/转账任意资产
2. 合约地址接收Ether需要有以下任一函数
   1. ` receive() external payable { }`
   2. `payable`修饰的`fallback()`: ` fallback() external payable { }`


## 攻击实现
1. 准备一个攻击合约，合约可以在部署阶段接收Ether，但是部署过后不能正常接受Ether
2. 攻击合约向目标合约转账，成为目标合约的`新King`
3. 由于攻击合约不存在接收资产的默认函数，因此任何转账操作都会失败
4. 目标合约中任何更高转账的操作都会回滚失败，因为 攻击合约作为 `旧King`无法接收`新King`的资金
```solidity
contract AttackKing {
   constructor() payable {}

   function attack(King _king, uint256 value) public payable {
      payable(address(_king)).call{value: value}("");
   }
}
```
## 实现步骤
1. 部署`AttackKing`合约，在部署阶段存入Ether
2. 调用`AttackKing`合约的`attack()`函数，底层`call King`合约
3. 此时，`King`合约下的`king`地址更新为`AttackKing`合约
4. 此后，任意地址的转账行为都会失败，因为 作为`旧king`的 `AttackKing`合约不支持转账操作
