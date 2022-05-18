import { Workflow } from '@anagolay/wf_file_multihash_cid'
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
  let file_url, is_default_url;
  if (process.argv.length <= 2) {
    file_url = "https://bafybeiavjzfgrxx2zq5r3vx352amhuzdv5pc5cu32xp7tlh4iqvcuxjcze.ipfs.dweb.link/tenerife-light-painting-01-1000x1000.jpg"
    is_default_url = true
  } else {
    file_url = process.argv[2]
    is_default_url = false
  }
  console.log("File is " + file_url)

  // Instance the Workflow
  let wf = new Workflow();

  // Run the next segment of the workflow
  let inputs = [file_url]
  let {done, output, total_time} = await wf.next(inputs);

  // Extract the output and some performance statistics
  assert(done, "Workflow is not finished")

  if (is_default_url) {
    assert("bafkr4ih2xmsije6aa6yfwjdfmztnnkbb6ip56g3ojfcyfgjx6jsh6bogoe" === output, "Wrong CID calculated")  
  }

  console.log('Execution time is:  %d millis', total_time.toFixed());
  console.log('Workflow computed CID: %s', output)
}

main().catch(console.error)
