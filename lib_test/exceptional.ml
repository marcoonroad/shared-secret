open OUnit2;;
open SharedSecret;;

module First  = Exception (String);;
module Second = Exception (String);;

let unsafe_first  ( ) = First.Raiser.raise  "Oops!"
let unsafe_second ( ) = Second.Raiser.raise "Hello, World!"

let first_handler  str = str
let second_handler str = str

let first_test  unsafe = First.Handler.handle  unsafe first_handler
let second_test unsafe = Second.Handler.handle unsafe second_handler

let caught_first  ctxt = assert_equal (first_test unsafe_first)   "Oops!"
let caught_second ctxt = assert_equal (second_test unsafe_second) "Hello, World!"

let uncaught_first ctxt =
  let uncaught = "Uncaught." in
  assert_equal (try (first_test unsafe_second) with _ -> uncaught) uncaught

let uncaught_second ctxt =
  let uncaught = "Uncaught." in
  assert_equal (try (second_test unsafe_first) with _ -> uncaught) uncaught

let suite =
  "suite" >::: [
    "caught_first"    >:: caught_first;
    "caught_second"   >:: caught_second;
    "uncaught_first"  >:: uncaught_first;
    "uncaught_second" >:: uncaught_second
  ];;

let _ =
  run_test_tt_main suite
