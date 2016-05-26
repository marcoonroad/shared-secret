[![Build Status](https://travis-ci.org/marcoonroad/shared-secret.svg?branch=master)](https://travis-ci.org/marcoonroad/shared-secret)

# shared-secret
Abstract (encapsulated) messages or hidden (semi-deterministic) exceptions using OCaml's module system.

A package inspired by this post: https://existentialtype.wordpress.com/2012/12/03/exceptions-are-shared-secrets/

### API

  This package actually provides only one module file called SharedSecret. This module contains 2 functors,
which are needed for different purposes. They are 'Message' and 'Exception', parameterized by:

```ocaml
sig type t end
```

but the Message functor is generative, so it also takes `( )`.

  The first is to encode and decode existentially typed values. The use becomes obvious when we declare an
exception of an existential type. For instance:

```ocaml
module StringMessage = Message (String) ( );;

exception AbstractString of StringMessage.t;;
```

  In the above example, StringMessage will contain 2 submodules with these signatures:

```ocaml
module Encoder : sig
  val encode : String.t -> StringMessage.t
end;;

module Decoder : sig
  val decode : StringMessage.t -> String.t
end;;
```

  So the `AbstractString` exception can be caught, but not decoded without `Decoder.decode`:

```ocaml
let open StringMessage in
try raise (AbstractString (Encoder.encode "Hello, OCaml!")) with
| AbstractString msg -> Decoder.decode msg;; (* = "Hello, OCaml!" *)
```

  This encoding/decoding process imposes no additional runtime costs, internally it is just
the identity function.

  On other hand, the Exception functor is used when we don't like to expose the exception itself,
thus is impossible to catch it by explicit binding (pattern matching), it can only be intercepted,
but not revealed without the proper handler.

```ocaml
module StringException = Exception (String);;

let unsafe ( ) = StringException.Raiser.raise "Hello, World!";;

try unsafe ( ) with
| _ -> ( );; (* // discards the exception, don't use it on production code *)

let open StringException in
Handler.handle unsafe (fun str -> str);; (* = "Hello, World!" *)
```

  By the above example, we can deduce the following signature of the submodules:

```ocaml
module Raiser : sig
  val raise : String.t -> 'a
end;;

module Handler : sig
  val handle : (unit -> 'a) -> (String.t -> 'a) -> 'a
end;;
```

EOF
