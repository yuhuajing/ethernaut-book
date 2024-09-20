# HigherOrder

## Reference
[HigherOrder](https://ethernaut.openzeppelin.com/level/30)

[HigherOrder.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/30-HigherOrder/HigherOrder.sol)

## 目标
成为合约的leaderShip

## 分析
## commander
```solidity
    uint256 public treasury;

    function registerTreasury(uint8) public {
        assembly {
            sstore(treasury_slot, calldataload(4))
        }
    }

    function claimLeadership() public {
        if (treasury > 255) commander = msg.sender;
        else revert("Only members of the Higher Order can become Commander");
    }
```
1. 只要 `treasury` 大于255，任何地址就可以成为 `commander`
2. `registerTreasury(uint8)` 通过 `uint8` 限制传参（最大值255）
3. 但是函数调用可以通过直接底层的call调用，`call` 调用中数据被编码成 `256bit` ,数值远大于255
4. 因此，只需要在 `calldata` 中输入任意大于 255 的数值就可以更新 `treasury` 的值
5. `0x211c85ab0000000000000000000000000000000000000000000000000000000000000100`
