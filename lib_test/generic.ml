open OUnit2;;
open SharedSecret;;

let (first, revoker) = Token.create ( );;
let (second, _)      = Token.create ( );;

let first_sealer  ( ) = Box.Sealer.seal first "Hello, OCaml!";;
let second_sealer ( ) = Box.Sealer.seal second "Hello, World!";;

let first_unsealer  = Box.Unsealer.unseal first;;
let second_unsealer = Box.Unsealer.unseal second;;

let first_against_first ctxt =
  assert_equal (first_unsealer (first_sealer ( ))) "Hello, OCaml!";;

let second_against_first ctxt =
  let failed = ref false in
 (try
    ignore (second_unsealer (first_sealer ( )))
  with Box.InvalidToken ->
    failed := true);
  assert_equal !failed true;;

let first_against_second ctxt =
  let failed = ref false in
 (try
    ignore (first_unsealer (second_sealer ( )))
  with Box.InvalidToken ->
    failed := true);
  assert_equal !failed true;;

let second_against_second ctxt =
  assert_equal (second_unsealer (second_sealer ( ))) "Hello, World!";;

let sealed = first_sealer ( );;

let revoke ( ) =
  try Token.revoke revoker with Token.AlreadyRevoked -> ( );;

let first_cant_seal ctxt =
  revoke ( );
  let failed = ref false in
 (try
    ignore (first_sealer ( ))
  with Token.RevokedToken ->
    failed := true);
  assert_equal !failed true;;

let first_cant_unseal ctxt =
  revoke ( );
  let failed = ref false in
 (try
    ignore (first_unsealer sealed)
  with Token.RevokedToken ->
    failed := true);
  assert_equal !failed true;;

let suite = "suite" >::: [
  "first_against_first"   >:: first_against_first;
  "second_against_first"  >:: second_against_first;
  "first_against_second"  >:: first_against_second;
  "second_against_second" >:: second_against_second;
  "first_cant_seal"       >:: first_cant_seal;
  "first_cant_unseal"     >:: first_cant_unseal
];;

let _ =
    run_test_tt_main suite
