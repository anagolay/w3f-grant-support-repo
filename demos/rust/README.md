# Hi and welcome to rust demo

This code is made to demonstrate execution of the created workflow. 

Follow these steps to get the demo running.

## Step 1

Find your workflow name in the CLI output. It looks like this `> Workflow name:  workflow_compute_cidv1`.

Find the `git` artifact CID, that is your executable code with WASM. You sould look for it in the table in the console output under the `{ Git: Null }` row.
## Step 2

Open the [./Cargo.toml](./Cargo.toml) and replace the `WORKFLOW_NAME` and `WORKFLOW_GIT_CID` with the values from above.

## Step 3

```sh
cargo run
```

You should see something like this ( with your git artifact cid ):

```
gitpod /workspace/w3f-grant-support-repo/demos/rust (project-idiyanale-phase1_milestone-2) $ cargo run
    Updating git repository `http://127.0.0.1:8080/ipfs/bafybeidmwf3v7hyyvi5jszj47etsoo6bxdrfuc3cdhyovkdjjqzh7rjhdm`
   Compiling workflow_compute_cidv1 v0.0.1 (http://127.0.0.1:8080/ipfs/bafybeidmwf3v7hyyvi5jszj47etsoo6bxdrfuc3cdhyovkdjjqzh7rjhdm#c7a8abc5)
   Compiling rust-demo v0.3.0 (/workspace/w3f-grant-support-repo/demos/rust)
    Finished dev [unoptimized + debuginfo] target(s) in 6.83s
     Running `target/debug/rust-demo`
File is https://ipfs.anagolay.network/ipfs/bafybeiavjzfgrxx2zq5r3vx352amhuzdv5pc5cu32xp7tlh4iqvcuxjcze/tenerife-light-painting-01-1000x1000.jpg
Execution time is: 145 millis
Workflow computed CID: bafkr4ih2xmsije6aa6yfwjdfmztnnkbb6ip56g3ojfcyfgjx6jsh6bogoe
gitpod /workspace/w3f-grant-support-repo/demos/rust (project-idiyanale-phase1_milestone-2) $ 
```

You can also specify an URL:

```sh
cargo run -- <your_url>

# or you can try this 
cargo run -- https://ipfs.anagolay.network/ipfs/bafybeidiqckvpknwussyli5r5vt65np7jiblh6m72xrwvgzy4usyrj6eva
```

> This will work for ANY publicly availale data.

## Step 4

There is no step 4. Congrats you have executed the Anagolay workflow. 🎉

We encourage you to check the code and experiment  

---

We would like to hear your thoughts and feedback, please send them via [Discord](https://discordapp.com/invite/fanBk5deyq) or [Matrix](https://matrix.to/#/#anagolay-general:matrix.org)

## License
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
