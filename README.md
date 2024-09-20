# Ethernue Development Book

<p align="center">
<img src="/src/images/intercall.png" alt="Ethernaut Book cover" width="360"/>
</p>

The full code of what we'll build is stored in a separate repository:

https://github.com/yuhuajing/ethernaut-book

You can read this book at:

https://yuhuajing.github.io/ethernaut-book

## Table of Contents
- [Fallback](01-Fallback/fallback.md)
- [Fallout](02-Fallout/Fallout.md)
- [CoinFlip](03-CoinFlip/CoinFlip.md)
- [Telephonr](04-Telephone/Telephone.md)
- [Token](05-Token/Token.md)
- [Delegation](06-Delegation/Delegate.md)
- [Force](07-Force/Force.md)
- [Vault](08-Vault/Vault.md)
- [King](09-King/King.md)
- [Reentrance](10-Reentrance/Reentrance.md)
- [Elevator](11-Elevator/Elevator.md)
- [Privacy](12-Privacy/Privacy.md)
- [GateKeeperOne](13-GatekeeperOne/GateKeeperOne.md)
- [GateKeeperTwo](14-GatekeeperTwo/GateKeeperTwo.md)
- [NaughtCoin](15-NaughtCoin/NaughtCoin.md)
- [Preservation](16-Preservation/Preservation.md)
- [Recovery](17-Recovery/Recovery.md)
- [AlienCodex](19-AlienCodex/AlienCodeX.md)
- [Denial](20-Denial/Denial.md)
- [Shop](21-Shop/Shop.md)
- [Dex](22-Dex/Dex.md)
- [DexTwo](23-DexTwo/DexTwo.md)
- [PuzzleWallet](24-PuzzleWallet/PuzzleWallet.md)
- [Motorbike](25-Motorbike/Motorbike.md)
- [DGoodSamaritan](27-GoodSamaritan/GoodSamaritan.md)
- [GatekeeperThree](28-GatekeeperThree/GateKeeperThree.md)
- [Switch](29-Switch/Switch.md)
- [HighOrder](30-HigherOrder/HigherOrder.md)
- [Stake](31-Stake/Stake.md)

## Running locally
To run the book locally:
1. Install [Rust](https://www.rust-lang.org/).
1. Install [mdBook](https://github.com/rust-lang/mdBook):
    ```shell
    $ cargo install mdbook
    $ cargo install mdbook-katex
    ```
1. Clone the repo:
    ```shell
    $ git clone https://github.com/yuhuajing/ethernaut-book
    $ cd ethernaut-book
    ```
1. Run:
    ```shell
    $ mdbook serve --open
    ```
1. Visit http://localhost:3000/ (or whatever URL the previous command outputs!)
