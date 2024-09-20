# Fallback
## Reference
[Fallback](https://ethernaut.openzeppelin.com/level/1)

[Sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/01-Fallback/Fallback.sol)

[fallback/receive](https://github.com/yuhuajing/solidityLearn/tree/main/smartContract)

## 目标
1. 成为合约Owner
2. 转走全部合约Ether

## 分析
合约一共有3个写函数（更新当前合约参数的函数）：
- contribute()
- withdraw()
- receive()

### contribute()
```solidity
    function contribute() public payable {
        // 要求交易金额小于 0.001 ether
        require(msg.value < 0.001 ether);
        // 增加贡献值
        contributions[msg.sender] += msg.value;
        // 贡献值最大的sender,成为新的Owner
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }
```
1. 这是个`payable`函数，支持接收`ether`，任何地址都可以调用函数，提供贡献值

### withdraw()
```solidity
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
```
1. `Owner` 账户提款合约的全部`Ether`

### receive()
```solidity
    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
```
1. `receive()` 函数作为接收`Ether`的回调函数，当合约接收Ether是会被调用
2. 只要转账金额不为0 并且 之前有过贡献值的话，`owner`的地址就会更新为当前交易的`Sender`
3. `fallback()` 函数作为解析`calldata`的兜底函数，如果当前合约不存在任何的函数选择器`Funcselector`,处理逻辑就会落到`fallback`函数，因此可以实现代理合约的逻辑

## 实现步骤
1. 部署合约
2. 调用`contribute()`函数，转入 `0.0005 ETH`，初始化 `contributions[msg.sender]` 值
3. 不通过合约函数，直接对合约转账任意金额，触发 `receiver` 函数，更新合约`Owner`
5. 调用`withdraw`，转移全部资产
