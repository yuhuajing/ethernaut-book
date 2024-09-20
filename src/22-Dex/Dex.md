# Dex

## Reference
[Dex](https://ethernaut.openzeppelin.com/level/22)

[Dex.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/22-Dex/Dex.sol)

## 目标
1. 玩家持有`TokenA，TokenB`各10个
2. Dex持有`TokenA，TokenB`各100个
3. 榨干Dex池子中的 `TokenA` 或 `TokenB`

## 分析
### price
```solidity
    function getSwapPrice(
    address from,
    address to,
    uint256 amount
) public view returns (uint256) {
    return ((amount * IERC20(to).balanceOf(address(this))) /
        IERC20(from).balanceOf(address(this)));
}
```
1. 在兑换Token时，依靠Dex池子中TokwnA/TokenB的数量锚定
2. 问题在于，每次交易完成后，都会更新当前池子的Token数量
 
   | playerTokenA  | playerTokenB | DexTokenA | DexTokenB |  
   |--------|--------------|-----------|-----------|
   | 10     | 10           | 100       | 100       | 
   | 0      | 20           | 110       | 90        | 
   | 24     | 0            | 86        | 110       | 
   | 0      | 30           | 110       | 80        | 
   | 41     | 0            | 69        | 110       |
   | 0      | 65           | 110       | 45        |
   | 110    | 20           | 0         | 90        |
3. 按照上述兑换表格，最后会清空 `Dex` 池子中的 `TokenA`，攻击者的 `(TokenA,TokenB)` 的余额从(10,10)更新为(110，20)。
