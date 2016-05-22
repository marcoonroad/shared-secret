module type IMessage = sig
  type t
  type a

  module Encoder : sig val encode : a -> t end;;
  module Decoder : sig val decode : t -> a end;;
end;;

module Message (Type : sig type t end) : IMessage with type a := Type.t = struct
  type t = Type.t

  module Encoder = struct let encode msg = msg end;;
  module Decoder = struct let decode msg = msg end;;
end;;

module type IException = sig
  type t

  module Raiser  : sig val raise  : t -> 'a end;;
  module Handler : sig val handle : (unit -> 'a) -> (t -> 'a) -> 'a end;;
end;;

module Exception (Type : sig type t end) : IException with type t := Type.t = struct
  exception Class of Type.t

  module Raiser = struct
    let raise value = raise (Class value)
  end;;
  
  module Handler = struct
    let handle unsafe handler = try unsafe ( ) with Class value -> handler value
  end;;
end;;
