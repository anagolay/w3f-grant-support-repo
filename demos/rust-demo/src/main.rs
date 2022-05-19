use core::any::Any;
use std::env;
use std::rc::Rc;
use wf_file_multihash_cid::Workflow;

#[tokio::main]
async fn main() {
    let args: Vec<String> = env::args().collect();

    // If no arguments are supplied, use default URL. Otherwise, use first argument
    let (file_url, is_default_url) = if args.len() == 1 {
        (String::from("https://ipfs.anagolay.network/ipfs/bafybeiavjzfgrxx2zq5r3vx352amhuzdv5pc5cu32xp7tlh4iqvcuxjcze/tenerife-light-painting-01-1000x1000.jpg"), true)
    } else {
        (args[1].clone(), false)
    };
    println!("File is {}", &file_url);

    // Instance the workflow
    let workflow = Workflow::new();

    // Run the next segment of the workflow
    let inputs: Vec<Rc<dyn Any>> = vec![Rc::new(file_url)];
    let result = workflow.next(inputs).await.unwrap();
    let result = result.as_ref();

    // Print the output and some performance statistics
    assert!(result.is_done(), "Workflow is not finished");
    let output = result
        .get_output()
        .unwrap()
        .downcast_ref::<String>()
        .unwrap()
        .clone();
    let total_time = result.get_total_time();

    if is_default_url {
        assert_eq!(
            "bafkr4ih2xmsije6aa6yfwjdfmztnnkbb6ip56g3ojfcyfgjx6jsh6bogoe", output,
            "Wrong CID calculated"
        );
    }
    println!("Execution time is: {} millis", total_time);
    println!("Workflow computed CID: {}", output);
}
