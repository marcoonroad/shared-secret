open OUnit2;;
open SharedSecret;;

(*
  'Cause OCaml has applicative functor semantics, two distinct instances
  of Message(String) shares the same abstract type t, which is Message(String).t,
  for this reason, I need to think a way out of it, where every instance, even
  sharing the same dependency (e.g, String), will fail when used one against other
  (e.g, encoding with the first and decoding with the second on the same message will
  be impossible). That thing means I should fake generative functor semantics.
*)

module First  = Message (String);;
module Second = Message (String);;

let first_encoder  ( ) = First.Encoder.encode  "Hello, OCaml!";;
let second_encoder ( ) = Second.Encoder.encode "Hello, World!";;

let first_decoder  = First.Decoder.decode
let second_decoder = Second.Decoder.decode

let first_against_first ctxt =
  assert_equal (first_decoder (first_encoder ( ))) "Hello, OCaml!";;

let second_against_first ctxt =
  assert_equal (second_decoder (first_encoder ( ))) "Hello, OCaml!";;

let first_against_second ctxt =
  assert_equal (first_decoder (second_encoder ( ))) "Hello, World!";;

let second_against_second ctxt =
  assert_equal (second_decoder (second_encoder ( ))) "Hello, World!";;

let suite = "suite" >::: [
  "first_against_first"   >:: first_against_first;
  "second_against_first"  >:: second_against_first;
  "first_against_second"  >:: first_against_second;
  "second_against_second" >:: second_against_second
];;

let _ =
    run_test_tt_main suite
