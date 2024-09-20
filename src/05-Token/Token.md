# Token
## Reference
[Token](https://ethernaut.openzeppelin.com/level/5)

[Sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/05-Token/Token.sol)

## 目标
1. 获取足够多的Token余额

## 分析
### Up to Solidity 0.8.0
1. 在solidity 0.8.0 之前的版本，数学计算需要采用 safeMath避免 数值 上下溢出。
2. 向下溢出： uint(-1) = uint256.Max
3. 向上溢出： uint256.max + 1 = 0

### transfer()
```solidity
    function transfer(address _to, uint256 _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
}
```
1. 合约版本 0.6.0， 存在数值上下溢出的风险，但是合约并未使用 safeMath
2. transfer()函数在用户转账时，并未进行 balance判断，而是直接进入余额的增减
3. 因此，transfer()函数中存在 balance为0 的用户的数值下溢问题

## 实现步骤
1. 部署`Token`合约
2. balance为0的发起者地址像任意地址转账，发起者的Token余额向下溢出，实现余额激增
