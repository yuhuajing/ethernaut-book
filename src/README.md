# Ethernue Development Book

<p align="center">
<img src="/images/intercall.png" alt="Ethernaut Book cover" width="360"/>
</p>

The full code of what we'll build is stored in a separate repository:

https://github.com/yuhuajing/ethernaut-book

You can read this book at:

https://yuhuajing.github.io/ethernaut-book

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
