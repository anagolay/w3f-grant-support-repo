import { Workflow } from '@anagolay/workflow_file_multihash_cid'
import { assert } from 'console'

// Polyfill fetch
import fetch from 'node-fetch';
import {Headers, Request, Response} from 'node-fetch';
global.fetch = fetch
global.Headers = Headers
global.Request = Request
global.Response = Response

async function main() {
  // If no arguments are supplied, use default URL. Otherwise, use first argument
  let fileUrl, isDefaultUrl;
  if (process.argv.length <= 2) {
    fileUrl = "https://ipfs.anagolay.network/ipfs/bafybeiavjzfgrxx2zq5r3vx352amhuzdv5pc5cu32xp7tlh4iqvcuxjcze/tenerife-light-painting-01-1000x1000.jpg"
    isDefaultUrl = true
  } else {
    fileUrl = process.argv[2]
    isDefaultUrl = false
  }
  console.log("File is %s", fileUrl)

  // Instance the Workflow
  let workflow = new Workflow();

  // Run the next segment of the workflow
  let inputs = [fileUrl]
  let {done, output, totalTime} = await workflow.next(inputs);

  // Print the output and some performance statistics
  assert(done, "Workflow is not finished")

  if (isDefaultUrl) {
    assert("bafkr4ih2xmsije6aa6yfwjdfmztnnkbb6ip56g3ojfcyfgjx6jsh6bogoe" === output, "Wrong CID calculated")  
  }

  console.log('Execution time is:  %d millis', totalTime.toFixed());
  console.log('Workflow computed CID: %s', output)
}

main().catch(console.error)
