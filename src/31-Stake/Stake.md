# Stake

## Reference
[Stake](https://ethernaut.openzeppelin.com/level/31)

[Stake.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/31-Stake/Stake.sol)

## 目标
掏空奖池

## 分析
### call()
call()函数返回执行结果和状态，但是在远端call交易失败的情况下，整笔交易不会回滚，因此需要判断返回的状态
```solidity
    function StakeWETH(uint256 amount) public returns (bool) {
        require(amount > 0.001 ether, "Don't be cheap");
        (, bytes memory allowance) = WETH.call( //allowance()
            abi.encodeWithSelector(0xdd62ed3e, msg.sender, address(this))
        );
        require(
            bytesToUint(allowance) >= amount,
            "How am I moving the funds honey?"
        );
        totalStaked += amount;
        UserStake[msg.sender] += amount;
        (bool transfered, ) = WETH.call(
            abi.encodeWithSelector(
                0x23b872dd, // transferFrom
                msg.sender,
                address(this),
                amount
            )
        );
        Stakers[msg.sender] = true;
        return transfered; // Not checking postposition
    }
```
1. 在质押WETH的交易中，仅仅检查了授权情况，在底层的转账 call中并没有实际检查转账状态
2. 授权交易不会判断余额
3. 存在无WETH钱包仅授权当前stake账户，实际转账交易无法执行。但是stake合约没有判断转账状态，直接更新当前质押余额
4. 因此，可以通过一直空质押WETH刷新增加质押余额，然后直接退款ETH，掏空奖池
