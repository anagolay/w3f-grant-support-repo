- [Anagolay project Idiyanale phase 1 (Nr. 1) - Milestone 2](#anagolay-project-idiyanale-phase-1-nr-1---milestone-2)
  - [Intro](#intro)
    - [Debugging and clean up if you need it](#debugging-and-clean-up-if-you-need-it)
  - [Updated Publish service](#updated-publish-service)
    - [Added new job -- `publishWorkflow`](#added-new-job----publishworkflow)
  - [Anagolay Operation Standard](#anagolay-operation-standard)
- [Deliverables](#deliverables)
  - [Article](#article)
  - [Workflows Pallet](#workflows-pallet)
  - [Anagolay CLI: Workflow manifest generation](#anagolay-cli-workflow-manifest-generation)
  - [Operation - op\_cid](#operation---op_cid)
  - [Operation - op\_multihash](#operation---op_multihash)
  - [Workflow: execution](#workflow-execution)
    - [WASM bindings](#wasm-bindings)
  - [Nodejs demo app - Part 1](#nodejs-demo-app---part-1)
  - [Rust demo crate - Part 2](#rust-demo-crate---part-2)
- [Building the Operations and Workflow](#building-the-operations-and-workflow)
  - [re-build op\_file](#re-build-op_file)
  - [build op\_multihash](#build-op_multihash)
  - [build op\_cid](#build-op_cid)


# Anagolay project Idiyanale phase 1 (Nr. 1) - Milestone 2

Hi and welcome to the support repo for the W3F grant [PR 719](https://github.com/w3f/Grants-Program/pull/719). This is a continuation of the previous [Milestone 1](https://github.com/anagolay/w3f-grant-support-repo/tree/project-idiyanale-phase1_milestone-1). Certain documentation and descriptions will **not** be duplicated but referenced. Removals are **not** indicated, only the **additions**.

## Intro

You can choose to open this repo in Gitpod or locally with [VsCode Devcontainer](https://code.visualstudio.com/docs/remote/containers). It will set up the environment, and all the dependencies and start all the docker containers which you will need for the successful demo.

Important new files and directories ( additions to the previous Milestone ):

- [.devcontainer/install-deps.sh](./.devcontainer/install-deps.sh) will 
  -  clone `op_multihash` repo
  -  clone `op_cid` repo
  -  update the Anagolay CLI
  -  install direnv
- [.gitpod.yml](./.gitpod.yml) for Gitpod integration

New components in this environment:

- Docker services
  - [WS Service](./docker-compose.yml#L17)
  - [Updated Anagolay Node](./docker-compose.yml#L24)
- [op_cid](https://gitlab.com/anagolay/operations/op_cid) repository cloned in the `./operations`
- [op_multihash](https://gitlab.com/anagolay/operations/op_multihash) repository cloned in the `./operations`

### Debugging and clean up if you need it

If you wish to get rid of the bootstrap nodes.
```sh
# every time you recreate the containers run this if you want to remove the bootstrap nodes
docker-compose exec ipfs ipfs bootstrap rm all \
&& docker-compose stop ipfs \
&& docker-compose up -d ipfs
```

Debugging and cleanup

```sh
# stop and remove all containers and their volumes, very useful when debugging
docker-compose down --volumes

# start all the containers again
docker-compose up -d
```

Attaching to the logs

```sh
# get the logs from the publish service.
docker-compose logs --follow publish
```

---

## Updated Publish service

> The explanation of this service is outlined in the [Milestone 1](https://github.com/anagolay/w3f-grant-support-repo/tree/project-idiyanale-phase1_milestone-1#what-is-a-publish-service), please go there to refresh your memory.


The update is related to the [Anagolay CLI: Workflow manifest generation](https://github.com/anagolay/Grants-Program/blob/a6bd87adb3331db6efc8e7a96106c8efd53e4e31/applications/anagolay-project-idiyanale-phase-1.md#anagolay-cli-workflow-manifest-generation) deliverable, initially thought to build and publish from the developers' machine, then we iterated over the idea and realized that approach would create potential vectors of the attack like the code injection ( for the generated JS files ), hijacking the Anagolay CLI extrinsic call, IPFS spamming, not having unified packages ( rust, node, cargo, ... ) for the reproducible builds. Due to these reasons ( and a few more ) we decided to update the publish service with a new job called `publishWorkflow` that unifies the environment and does all the building and publishing to the IPFS then returns the response in a structured way so the Anagolay CLI can use it. Additionally, the service stores the built responses in MongoDB for future queries and to prevent unnecessary builds. The unique id is the concatenation of Operation version IDs from the Workflow segments. 

### Added new job -- `publishWorkflow`

Steps:

- clone the [Workflow template git repository](https://gitlab.com/anagolay/anagolay-workflow-template)
- generate the source code from the segments and the Operation Artifact version
- upload the generated Workflow git repository to IPFS
- build the Workflow code and produce WASM artifacts
- upload the artifacts on IPFS
- cleanup the working directory and return the IPFS CID of every hosted content

> If you didn't change the `env` file the API key is not needed even though the API documentation says that it is used.


## Anagolay Operation Standard

In Milestone 2 we have done a lot of code optimizations for the whole Operation structure and connected components and modules. 

Every Anagolay operation must conform to this internal standard.

Every operation must depend on:

- `an-operation-support`: the library crate, intended to be the only package a new Operation must depend on it
- `an-operation-support-macros`: a procedural macro crate needs to be separate from the rest of the library but it's re-exported by an-operation-support

Every operation must implement the Anagolay Operation Support `describe` macro to annotate the main `execute` function with correct inputs and flags.

Operation will:

- compile to `nostd` or not -- operation _must_ set `nostd=false` if it doesn't intend (or can't) support `nostd`
- create binary -- `main.rs`
- create library -- `lib.rs`
- create artifacts
  - wasm artifacts for the following [Package types](https://gitlab.com/anagolay/anagolay/-/blob/c1a407db8955c8e9de856df69732dcb30337e569/pallets/operations/src/types.rs#L123)
  - create rustdocs -- this is automatically uploaded to IPFS in the publish service
  - rehost the repository -- rehosted HEAD commit

The source code structure is simple and minimal. Every Operation must have the same structure, and export the same methods, like `execute`, for both wasm and rust environments. The wasm-related functions are located in the `wasm.rs` file.

Useful links:

- [Anagolay Operation Support](https://gitlab.com/anagolay/an_operation_support)


# Deliverables

List of deliverables for Milestone 2. 

## Article

The article is published on our blog -> https://blog.anagolay.network/articles/project-idiyanale-phase-1/milestone-2.html

## Workflows Pallet

As per grant [Milestone 2 deliverable](https://github.com/anagolay/Grants-Program/blob/a6bd87adb3331db6efc8e7a96106c8efd53e4e31/applications/anagolay-project-idiyanale-phase-1.md#substrate-module---an_workflow) we have implemented the pallet which you can see [here](https://gitlab.com/anagolay/anagolay/-/tree/05bed7ddadae4329f4915942e73fa755b092985a/pallets/workflows) with all the functionality explained in the grant. This pallet is used directly by the Anagolay CLI for storing the Workflow Manifest and its Artifacts.

The `workflow` pallet at the moment shares a lot of similarities with the Operation pallet, which is the intended way and because of this, we needed to refactor the Operation pallet and extract the previously known `Operation Version` which became the `Artifact`. Its definition is moved to the `anagolay-support` pallet and now both, Operation and Workflow pallet must implement their Artifact types and store them in their storage. This way we solved the issue of standardizing the Artifact on the chain improving the overall performance and security.

This part also includes the `Benchmarks: an_workflow` deliverable.

## Anagolay CLI: Workflow manifest generation

As per grant Milestone 2 deliverable [Anagolay CLI: Workflow manifest generation](https://github.com/anagolay/Grants-Program/blob/a6bd87adb3331db6efc8e7a96106c8efd53e4e31/applications/anagolay-project-idiyanale-phase-1.md#anagolay-cli-workflow-manifest-generation) we have implemented the workflow creation process in a more developer-friendly way. 

This includes the creation of two non-planned components:

- WebSocket microservice for communication between the web app and the CLI
- Svelte based, static web app with the connection to Anagolay chain and Anagolay WebSocket microservice with easy to use interactive workflow creation

Due to the changes, this deliverable as described in the grant is not fully covering the workflow creation. To have consistency here is the summary of the processes and the workflow creation.

The command that starts the workflow creation is `anagolay workflow create` then the CLI is will create the link that the developer will open to start with the workflow creation. The developer will create the workflow by connecting the operations and filling in the form fields. When ready and given the workflow is correct `SAVE` button will be enabled. Clicking the `SAVE` button will send the message to the WS to a specific channel on which the CLI is listening. This will trigger the `Account selection` where the developer can decide which account to use, `Alice` or `Personal`. After that is done the payload is sent to the Publish service which will generate the code, build and upload the artifacts then return the payload to CLI which will start saving the data on the chain. Success will yield the output shown below.

The UI looks like this:

![Anagolay workflow builder](https://bafybeidiqckvpknwussyli5r5vt65np7jiblh6m72xrwvgzy4usyrj6eva.ipfs.anagolay.network)

The Workflow generation output looks like this:

![Workflow Compute CIDv1](https://bafybeie3b63h32hfodt546rwynpobsbejjrco43msr75mmjfqlrnx3sljm.ipfs.anagolay.network)

The data used for the generation of the Workflow from above is: 

```ini
name        = Workflow Compute CIDv1
description = Generic CIDv1 computation of any data. Use base32 encoding with Blake3-256 hasher.
groups = Generic, SYS
```

**It's very important to note that all WASM artifacts are deterministic for a given manifest. The only one that it's not is the `git` artifact. This means that if you try to build the workflow with the above data on the same machine as we did ( this support repo ) you must get the same CIDs for WASM artifacts. Code assurance at its best!**


An example of how to create the workflow step by step is in our article on this [link](todo-link to the article).

## Operation - op_cid

As per grant Milestone 2 deliverable [Operation - op_cid](https://github.com/anagolay/Grants-Program/blob/a6bd87adb3331db6efc8e7a96106c8efd53e4e31/applications/anagolay-project-idiyanale-phase-1.md#operation---op_cid) deliverable we have implemented the Operation as per our design and idea of how it should work, which is also shared in the grant document.

The `op_cid`:
- conforms to the [Anagolay Operation Standard](#anagolay-operation-standard)
- can be used in the `nostd` env
- is using `base32` as a multibase and `RAW` as a multicodec

Useful Links:

- [op_cid repository](https://gitlab.com/anagolay/operations/op_cid)
- [Latest docs](https://ipfs.anagolay.network/ipfs/bafybeidwtifwwtr344kywifknwurbh5lieh27cz6rshawd5kmuilir6kxy/op_cid/index.html)
  
## Operation - op_multihash

As per grant Milestone 2 deliverable [Operation - op_multihash](https://github.com/anagolay/Grants-Program/blob/a6bd87adb3331db6efc8e7a96106c8efd53e4e31/applications/anagolay-project-idiyanale-phase-1.md#operation---op_multihash) deliverable we have implemented the Operation as per our design and idea of how it should work, which is also shared in the grant document.

This operation is slightly different than the other two operations because it's the first one to use the `config` manifest property to give a developer two options for hashing. This is used in the Workflow creation step.

The `op_multihash`:
- conforms to the [Anagolay Operation Standard](#anagolay-operation-standard)
- can be used in the `nostd` env
- is using `Blake3-256` or `Sha2-256` hashers

Useful Links:

- [op_multihash repository](https://gitlab.com/anagolay/operations/op_multihash)
- [Latest docs](https://ipfs.anagolay.network/ipfs/bafybeigzkhk44xchamjsgtpmtigorkwh3q2efr4ud6vbelooweoff42uae/op_multihash/index.html)


## Workflow: execution

As per grant Milestone 2 deliverable [Workflow: execution](https://github.com/anagolay/Grants-Program/blob/a6bd87adb3331db6efc8e7a96106c8efd53e4e31/applications/anagolay-project-idiyanale-phase-1.md#workflow-execution) deliverable we have implemented the Workflow execution as per our design and idea of how it should work, which is also shared in the grant document.

The core of the Workflow execution is `Segments`, a list of operations in a specific order which produces the result. All Operations that don’t require any additional input than the output of the previously executed Operation, can be executed sequentially in a Segment without any user intervention and without the need to cross the WASM boundary to propagate the previous output toward the next input. 

![Workflow execution segments](https://bafybeiadczp6uf7rvbyjbw4oxdj7hbubicx2ph4j2m66qfeylwquneml7e.ipfs.anagolay.network)

### WASM bindings

As it may now sound like a familiar analogy, also Workflows have a WASM binding, just like Operations do. While possible, executing manually Operation after Operation through their WASM interface, in the order that satisfies their dependencies, serializing every output, and deserializing every input is not only cumbersome and inefficient but also repetitive and error-prone. This is why Workflows exist and may also achieve better performance.

> There is no WASM boundary crossing in executing operations of the same segment, and the Segment result is deserialized for the caller only at the end of the Workflow.


Therefore the native Workflow interface and its WASM binding expose the following methods:

- `new()`: creates a new instance of the Workflow, initializing its state
- `next()`: accepts the external inputs and invokes the execution of the next segment. Only user (or external) inputs are needed as parameters; the input coming from previously executed Segments is known in the Workflow state and is handled automatically

It may help to think about a Workflow as an application of the [generator pattern](https://en.wikipedia.org/wiki/Generator_(computer_programming)). According to this definition, every call to `next()` returns an object with the following properties:

- `done`: boolean that indicates if the Workflow execution has been completed
- `output`: only available in the last Segment execution, when `done` is true since producing a result every call to `next()` implies a performance penalty
- `segmentTime`: performance measurement of the time taken to execute the segment
- `totalTime`: performance measurement of the time taken to execute the Workflow up to the current Segment

>In Rust, these fields are exposed as getters from the interface `SegmentResult`. To deal with the type variance in input and outputs, Rust makes use of type [Any](https://doc.rust-lang.org/std/any/index.html), whose reference can be downcast to the expected type.

## Nodejs demo app - Part 1
Before you start with the demo follow [Building the Operations and Workflow](#building-the-operations-and-workflow) because this will explain to you how to get to the correct workflow CID.

Please follow the [README.md](./demos/nodejs/README.md) in the nodejs demo directory.

## Rust demo crate - Part 2

Before you start with the demo follow [Building the Operations and Workflow](#building-the-operations-and-workflow) because this will explain to you how to get to the correct workflow CID.

Please follow the [README.md](./demos/rust/README.md) in the rust demo directory.

# Building the Operations and Workflow
To run the demos, you need the generate the source code and artifacts. If this would be a real-world scenario, you would get them via a package manager, since this is a self-containing support repo, you need to build them yourself. 

> The snippets are taken from the gitpod, you can use the devcontainer as well, the `workspace` paths will be different, and the devcontainer will have `/workspace` instead of 
`/workspace/w3f-grant-support-repo`.

For the simplicity of the executions, I will add only outputs in the correct order for you to see and execute the first lines.

## re-build op_file
```
gitpod /workspace/w3f-grant-support-repo/operations/op_file (main) $ anagolay operation publish
✔  success   Sanity checks, done!
  ◝ Checking if the remote job is done. This can take a while.
ℹ  info      Connected to Anagolay Node v0.3.0-0bd52ee-x86_64-linux-gnu
? Which account do you want to use to sign the transaction? Use Alice
> TX is at blockHash 0x50f4616f27f3a83f877d80bcb9e7b6c4e4a33c4af915ac18f743ff27c7126e3b
> Manifest ID is bafkr4igxckwhvpd47nrhdjbdun3wrw24cnhrodnvydxxo27bdifep5dr7q
Artifacts and their types.
┌─────────┬──────────────────┬───────────────────────────────────────────────────────────────┐
│ (index) │       type       │                              cid                              │
├─────────┼──────────────────┼───────────────────────────────────────────────────────────────┤
│    0    │  { Git: null }   │ 'bafybeic56c277zlm543hkptt55rmdtsg6nfjlnvezj62fokhxmggqobxq4' │
│    1    │ { Wasm: 'Esm' }  │ 'bafybeifio5pvhwrzwosro6lenjll7thnikmxmqvjnzstz2vwlpv2k2qsne' │
│    2    │ { Wasm: 'Web' }  │ 'bafybeieusvzktswmwzag3ulu7ulbsf6mls6zopbqcjdsvity4dbeumcexe' │
│    3    │ { Wasm: 'Cjs' }  │ 'bafybeigi6hhz6gxv3elmxdcfqjhcaqvjvfzgwvsj6hy77ulef2udky6z2q' │
│    4    │ { Wasm: 'Wasm' } │ 'bafybeibrod5nsubitx5v4uolnts4qu5fgrcuhrbfkum3f664vtim53anjy' │
│    5    │  { Docs: null }  │ '**bafybeibtseepqurn3l4hizsibenovmcvdqdambziggqh2ods7ty2iaa32y**' │
└─────────┴──────────────────┴───────────────────────────────────────────────────────────────┘
Total execution elapsed time: 4:47.043 (m:ss.mmm)
✔  success   DONE 🎉🎉!
```

## build op_multihash

```
gitpod /workspace/w3f-grant-support-repo/operations/op_multihash (main) $ anagolay operation publish
✔  success   Sanity checks, done!
ℹ  info      Connected to Anagolay Node v0.3.0-0bd52ee-x86_64-linux-gnu
? Which account do you want to use to sign the transaction? Use Alice
> TX is at blockHash 0x65b7de2a0a0bf7b049b5c2b306e3df6ccf64baaf71f3c02c78d284c35e083cc6
> Manifest ID is bafkr4id2aod4g3vg3b5exzi2rorvu44my63o6fcjfqihydkvcdrsd33hlq
Artifacts and their types.
┌─────────┬──────────────────┬───────────────────────────────────────────────────────────────┐
│ (index) │       type       │                              cid                              │
├─────────┼──────────────────┼───────────────────────────────────────────────────────────────┤
│    0    │  { Git: null }   │ 'bafybeifdnvwcj6lxnyfjytief3ftvcqqavwel3bfgf7ee3o4norawp5rne' │
│    1    │ { Wasm: 'Esm' }  │ 'bafybeiatou2kkkzrzxzidbz7y2mho2y7md7csbg7ufm5tu32icy45qwuda' │
│    2    │ { Wasm: 'Web' }  │ 'bafybeigus5n53n7ebv22jzlkamfbnsrew3nx5smxdwhdnu63abu5op4yru' │
│    3    │ { Wasm: 'Cjs' }  │ 'bafybeiggb2q4vt2oj3vyqrl4x2ax6bumrumkxos2vfl2lwwiawf6dt26ma' │
│    4    │ { Wasm: 'Wasm' } │ 'bafybeibn7lffaeqhln3i7eumkepwmkxgb5cisfpfnva3uo4m2nxmr66ln4' │
│    5    │  { Docs: null }  │ 'bafybeigzkhk44xchamjsgtpmtigorkwh3q2efr4ud6vbelooweoff42uae' │
└─────────┴──────────────────┴───────────────────────────────────────────────────────────────┘
Total execution elapsed time: 2:51.183 (m:ss.mmm)
✔  success   DONE 🎉🎉!
```

## build op_cid

```
gitpod /workspace/w3f-grant-support-repo/operations/op_cid (main) $ anagolay operation publish
✔  success   Sanity checks, done!
ℹ  info      Connected to Anagolay Node v0.3.0-0bd52ee-x86_64-linux-gnu
? Which account do you want to use to sign the transaction? Use Alice
> TX is at blockHash 0xce44d350cf94ed84d55428c0f9e62ac9afc509b7a462707a2908641c89fb34f6
> Manifest ID is bafkr4if466wjv6qrwp7gppvobhaa5hwahvowu2ox2cppydykx6h3ygqz5i
Artifacts and their types.
┌─────────┬──────────────────┬───────────────────────────────────────────────────────────────┐
│ (index) │       type       │                              cid                              │
├─────────┼──────────────────┼───────────────────────────────────────────────────────────────┤
│    0    │  { Git: null }   │ 'bafybeib4em2zvtqjsrrd2hg2n2ms4g7efmrmod3nilwalroj3dzl47cnea' │
│    1    │ { Wasm: 'Esm' }  │ 'bafybeiaaeanc56ebhxj55rgvasmrkufv4pb2ih6zm224s4plexcnvgugdq' │
│    2    │ { Wasm: 'Web' }  │ 'bafybeihtencrpcdgif4dp3z2uwtdwa6nf3bnrozuhm3njk3shx3a3jxi3y' │
│    3    │ { Wasm: 'Cjs' }  │ 'bafybeib2kzhoaori4vkogjiwigzp4ilwxpjm4yzxm4c4moj5gej2wzgj34' │
│    4    │ { Wasm: 'Wasm' } │ 'bafybeicrv7zh5guoztp2be4hl45xu77ijbabet6frzlesgbwywxoz4pitu' │
│    5    │  { Docs: null }  │ 'bafybeidwtifwwtr344kywifknwurbh5lieh27cz6rshawd5kmuilir6kxy' │
└─────────┴──────────────────┴───────────────────────────────────────────────────────────────┘
Total execution elapsed time: 2:40.845 (m:ss.mmm)
✔  success   DONE 🎉🎉!
```

After you are done with this follow the [Workflow creation](#anagolay-cli-workflow-manifest-generation) and that's that! 🥳

**Note that ALL artifacts will be the same in your build. This is the 100% source code and execution code assurance we are bringing to the proof verification and creation.**


🔗 Useful links:

- All the code for the Workflow publish can be found [here](https://gitlab.com/anagolay/micro-services/-/blob/main/services/publish/src/jobs/publishWorkflow.ts#L37)
- The API documentation is located [here](https://documenter.getpostman.com/view/2220022/UVktpYgR)
- Micro-services repository: https://gitlab.com/anagolay/micro-services
- OCI Publish Service: https://hub.docker.com/r/anagolay/microservices-publish
- OCI Websocket Service: https://hub.docker.com/r/anagolay/microservices-ws-server
- OCI Anagolay Node: https://hub.docker.com/r/anagolay/anagolay
- [Latest Anagolay Node docs](https://ipfs.anagolay.network/ipfs/bafybeieljedhisdrctlm7alv7j72rogg3zbjgj76ev3dhhjljc7dcjf6l4/anagolay/index.html)
- [Anagolay Custom Types](https://ipfs.anagolay.network/ipfs/bafybeidfrwn357dhagezj23g7nrrbkvzjvltchb4tdnqweg5ay4hs73gym) for the usage with [PolkadotApp](https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer)
- [Anagolay Node repository](https://github.com/anagolay/anagolay-chain)
