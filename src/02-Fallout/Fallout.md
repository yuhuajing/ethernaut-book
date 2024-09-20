# Fallout
## Reference
[Fallout](https://ethernaut.openzeppelin.com/level/2)

[sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/02-Fallout/Fallout.sol)

## 目标
1. 成为合约Owner

## 分析
### Up to Solidity 0.4.21
在solidity 0.4.21之前的版本，构造函数和合约同名:
```solidity
pragma solidity <=0.4.21;

contract Oldie {

    uint randomvar;
    function Oldie(uint _randomvar) public {     // Constructor
        randomvar = _randomvar;
    }
}
```
### Above to Solidity ^0.4.21
在solidity `^0.4.21`以及之后的版本，有专门初始化合约参数的构造函数 `constructor()` :
```solidity
    constructor (uint _randomvar) public {    // New Constructor
        randomvar = _randomvar;
    }
```

## 合约问题
### Unspelled 构造函数
1. 合约版本已经 `^0.6.0`，应付使用`constructor(){}`作为构造函数
2. 合约在高版本中使用了已经弃用的构造函数，并且函数拼写错误以及没有任何权限控制
3. 更新`storage`参数应该具有严格的权限管控，合约对于`Owner`地址的更新没有提供任何限制，任何地址都可以`call fal1out()`函数更改`owner`地址。
```solidity
    /* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }
```

## 实现步骤
1. 部署合约
2. 直接调用 `fal1out()` 函数，更新全局`Owner`
