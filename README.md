# Ethernue Development Book

<p align="center">
<img src="/src/images/intercall.png" alt="Ethernaut Book cover" width="360"/>
</p>

The full code of what we'll build is stored in a separate repository:

https://github.com/yuhuajing/ethernaut-book

You can read this book at:

https://yuhuajing.github.io/ethernaut-book

## Table of Contents
- [Fallback](src/01-Fallback/Fallback.md)
- [Fallout](src/02-Fallout/Fallout.md)
- [CoinFlip](src/03-CoinFlip/CoinFlip.md)
- [Telephonr](src/04-Telephone/Telephone.md)
- [Token](src/05-Token/Token.md)
- [Delegation](src/06-Delegation/Delegate.md)
- [Force](src/07-Force/Force.md)
- [Vault](src/08-Vault/Vault.md)
- [King](src/09-King/King.md)
- [Reentrance](src/10-Reentrance/Reentrance.md)
- [Elevator](src/11-Elevator/Elevator.md)
- [Privacy](src/12-Privacy/Privacy.md)
- [GateKeeperOne](src/13-GatekeeperOne/GateKeeperOne.md)
- [GateKeeperTwo](src/14-GatekeeperTwo/GateKeeperTwo.md)
- [NaughtCoin](src/15-NaughtCoin/NaughtCoin.md)
- [Preservation](src/16-Preservation/Preservation.md)
- [Recovery](src/17-Recovery/Recovery.md)
- [AlienCodex](src/19-AlienCodex/AlienCodeX.md)
- [Denial](src/20-Denial/Denial.md)
- [Shop](src/21-Shop/Shop.md)
- [Dex](src/22-Dex/Dex.md)
- [DexTwo](src/23-DexTwo/DexTwo.md)
- [PuzzleWallet](src/24-PuzzleWallet/PuzzleWallet.md)
- [Motorbike](src/25-Motorbike/Motorbike.md)
- [DGoodSamaritan](src/27-GoodSamaritan/GoodSamaritan.md)
- [GatekeeperThree](src/28-GatekeeperThree/GateKeeperThree.md)
- [Switch](src/29-Switch/Switch.md)
- [HighOrder](src/30-HigherOrder/HigherOrder.md)
- [Stake](src/31-Stake/Stake.md)

## Running locally
To run the book locally:
1. Install [Rust](src/https://www.rust-lang.org/).
1. Install [mdBook](src/https://github.com/rust-lang/mdBook):
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
