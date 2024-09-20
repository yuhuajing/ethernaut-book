// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Dex is Ownable(msg.sender) {
    address public token1;
    address public token2;

    constructor() {}

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function addLiquidity(address token_address, uint256 amount)
    public
    onlyOwner
    {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount); // sender 授权合约
    }

    function swap(
        address from,
        address to,
        uint256 amount
    ) public {
        require(
            (from == token1 && to == token2) ||
            (from == token2 && to == token1),
            "Invalid tokens"
        );
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );
        uint256 swapAmount = getSwapPrice(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount); // 需要 sender授权 swap
        // IERC20(to).approve(address(this), swapAmount); //授权参数应该是spender的地址
        //IERC20(to).transferFrom(address(this), msg.sender, swapAmount);//不能使用transferFrom
        IERC20(to).transfer(msg.sender, swapAmount); //不能使用transferFrom
    }

    function getSwapPrice(
        address from,
        address to,
        uint256 amount
    ) public view returns (uint256) {
        return ((amount * IERC20(to).balanceOf(address(this))) /
            IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint256 amount) public {
        SwappableToken(token1).approve(msg.sender, spender, amount);
        SwappableToken(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(address token, address account)
    public
    view
    returns (uint256)
    {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableToken is ERC20 {
    address private _dex;

    constructor(
        address dexInstance,
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
    }

    function approve(
        address owner,
        address spender,
        uint256 amount
    ) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}

contract Attack {
    Dex public dex;
    SwappableToken public tokenA;
    SwappableToken public tokenB;

    constructor() {
        dex = new Dex();
        tokenA = new SwappableToken(address(dex), "AAA", "aaa", 110); // mint 1000Token to address(this)
        tokenB = new SwappableToken(address(dex), "BBB", "bbb", 110);
    }

    function attack() public {
        dex.setTokens(address(tokenA), address(tokenB));
        tokenA.approve(address(dex), 100);
        tokenB.approve(address(dex), 100);
        dex.addLiquidity(address(tokenA), 100);
        dex.addLiquidity(address(tokenB), 100);
        tokenA.transfer(msg.sender, 10);
        tokenB.transfer(msg.sender, 10);
        tokenA.approve(msg.sender, address(dex), 200);
        tokenB.approve(msg.sender, address(dex), 200);
    }

    function balance(
        address from,
        address to,
        uint256 amount
    )
    public
    view
    returns (
        uint256 playerA,
        uint256 playerB,
        uint256 dexA,
        uint256 dexB
    )
    {
        playerA = tokenA.balanceOf(msg.sender);
        playerB = tokenB.balanceOf(msg.sender);
        dexA = tokenA.balanceOf(address(dex));
        dexB = tokenB.balanceOf(address(dex));
    }
}
