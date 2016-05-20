module type ExceptionSig = sig
  type t

  module Raiser  : sig val raise  : t -> 'a end;;
  module Handler : sig val handle : (unit -> 'a) -> (t -> 'a) -> 'a end;;
end;;

module Exception (Type : sig type t end) : ExceptionSig with type t := Type.t = struct
  exception Class of Type.t

  module Raiser = struct
    let raise value = raise (Class value)
  end;;
  
  module Handler = struct
    let handle unsafe handler = try unsafe ( ) with Class value -> handler value
  end;;
end;;
