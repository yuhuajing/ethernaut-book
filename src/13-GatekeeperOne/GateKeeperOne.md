# GatekeeperOne

## Reference
[GatekeeperOne](https://ethernaut.openzeppelin.com/level/13)

[GateKeeperOne.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/13-GatekeeperOne/GatekeeperOne.sol)

## 目标
1. 找出目标合约的正确答案

## 合约规则
### sender
```solidity
msg.sender != tx.origin
```
1. 合约之间的`call`会改变当前EVM执行环境，当前交易的`sender`更新为`caller`,和交易的源头发起者不一致
### BitChange
```solidity
uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
uint32(uint64(_gateKey)) != uint64(_gateKey),
uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))
require(gasleft() % 8191 == 0, "Invalid gas");
```
1. solidity中从低位取数据，例如 `uint32 var=0x12345678, uint16(var) = 0x5678`
2. 低位64位中： 
   1. 再从低位取得的32位：
      1. 和64位数字不同
      2. 和低位的16位数字不同
3. 也就是 64位数据和32位数据不同，32位数据和16位数据不同
4. 交易发起原始地址的后16位 和 当前 key的后32位保持一致
5. 执行环境的剩余`gasleft`是 8191的倍数

### 分析
1. 问题1需要实现攻击合约，通过底层call调用的方式达成第一个条件
2. 问题2中最多位数数据是64位，通过 获取 当前交易源头地址的 最后64位数据，通过处理后达成条件2
   1. Key的后32位和 `tx.origin` 的后16位相同：Key = 源数据 `& 0x????????0000FFFF`, ?任意
   2. Key的32位和16位相同：源数据 `& 0x????????0000FFFF`, ?任意
   3. Key的64位和32位不同： 源数据 `& 0x????????0000FFFF`, ? 任一为1即可
3. 源数据 `& 0xFF0000FF0000FFFF`
4. `bytes8(uint64(tx.origin) & 0xFF0000FF0000FFFF`

## 合约问题
1. 约束条件直接写在合约，没有地址权限控制以及随机值管控
2. 明文规则可以直接在链下迭代计算得出正确答案
