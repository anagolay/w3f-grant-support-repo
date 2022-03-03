use std::{collections::BTreeMap, env, time::Instant};

#[tokio::main]
async fn main() {
  let args: Vec<String> = env::args().collect();

  // If no arguments are supplied, use default URL. Otherwise, use first argument
  let file_url = if args.len() == 1 {
    String::from("https://ipfs.anagolay.network/ipfs/bafybeiavjzfgrxx2zq5r3vx352amhuzdv5pc5cu32xp7tlh4iqvcuxjcze/tenerife-light-painting-01-1000x1000.jpg")
  } else {
    args[1].clone()
  };
  println!("File is {}", &file_url);

  // Measure performance
  let now = Instant::now();

  // Await operation execution. No configuration needed
  let config = BTreeMap::new();
  let output = op_file::execute(&file_url, config).await.unwrap();

  let exec_time = now.elapsed().as_millis() as usize;

  // Output some statistics
  println!("Execution time is: {} millis", exec_time);
  println!("Operation output size: {:?} bytes", output.decode().len());
}
