module type IMessage = sig
  type t
  type a

  module Encoder : sig val encode : a -> t end;;
  module Decoder : sig val decode : t -> a end;;
end;;

module Message : functor (Type : sig type t end) ( ) -> (IMessage with type a := Type.t);;

module type IException = sig
  type t

  module Raiser  : sig val raise  : t -> 'a end;;
  module Handler : sig val handle : (unit -> 'a) -> (t -> 'a) -> 'a end;;
end;;

module Exception : functor (Type : sig type t end) -> (IException with type t := Type.t);;

(* end *)
