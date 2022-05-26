# Hi and welcome to nodejs demo

This code is made to demonstrate execution of the created workflow. 

Follow these steps to get the demo running.

## Step 1

Find your workflow name in the CLI output. It looks like this `> Workflow name:  workflow_compute_cidv1`.

Find the `CJS` artifact CID, that is your executable code with WASM. You sould look for it in the table in the console output under the `{ Wasm: 'Cjs' }` row.
## Step 2

Open the [./package.json](./package.json) and replace the `WORKFLOW_NAME` and `WORKFLOW_CJS_CID` with the values from above.

If you created the workflow with the provided example in the [root Readme](../../README.md) then you can just use this: 

```
"@anagolay/workflow_compute_cidv1": "http://127.0.0.1:8080/ipfs/bafybeig6xjivvki5n7t4enmzcen2lpl4mdpnb3gmvoefcougd7s7xwiwha"
```

> This is possible because Anagolay Workflow WASM artifacts are deterministic in build.

## Step 3

```sh
pnpm i
pnpm start
```

You should see this:

```
gitpod /workspace/w3f-grant-support-repo/demos/nodejs (project-idiyanale-phase1_milestone-2) $ pnpm start

> @anagolay/w3f_node_demo_app@0.3.0 start /workspace/w3f-grant-support-repo/demos/nodejs
> node --experimental-modules --experimental-wasm-modules ./src/index.js

File is https://ipfs.anagolay.network/ipfs/bafybeiavjzfgrxx2zq5r3vx352amhuzdv5pc5cu32xp7tlh4iqvcuxjcze/tenerife-light-painting-01-1000x1000.jpg
Execution time is:  147 millis
Workflow computed CID: bafkr4ih2xmsije6aa6yfwjdfmztnnkbb6ip56g3ojfcyfgjx6jsh6bogoe
gitpod /workspace/w3f-grant-support-repo/demos/nodejs (project-idiyanale-phase1_milestone-2) $ 
```


You can also specify an URL:

```sh
pnpm start <your_url>

# or you can try this 
pnpm start https://ipfs.anagolay.network/ipfs/bafybeidiqckvpknwussyli5r5vt65np7jiblh6m72xrwvgzy4usyrj6eva
```

> This will work for ANY publicly availale data.

## Step 4

There is no step 4. Congrats you have executed the Anagolay workflow. 🎉

We encourage you to check the code and experiment, there are 3 more variants `Esm`, `Wasm` and `Web` you can try out.  

---

We would like to hear your thoughts and feedback, please send them via [Discord](https://discordapp.com/invite/fanBk5deyq) or [Matrix](https://matrix.to/#/#anagolay-general:matrix.org)

## License
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
