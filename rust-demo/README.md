# rust-demo

Demonstrate execution of the wf_file_multihash_cid workflow. This workflow computes the CID of a 
file given its URL. Retrieved by an HTTP call, the content of the file is hashed using Blake3 and 
a CID v1 is computed afterwards.

The main function accepts an argument which is the URL of the file to fetch. If no argument is passed,
a default URL is used

## Usage

To build:

```sh
cargo build
```

To fetch the default url:

```sh
cargo run
```

If you want to specify an URL to fetch

```sh
cargo run -- <your_url>
```

## License
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
