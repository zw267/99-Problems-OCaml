(* Problem:
 * Determine the prime factors of a given positive integer.
 * Contruct a flat list containing the prime factors in ascending order
 *)

exception InvalidInput

let is_prime (n : int) : bool =
  if n <= 0 then raise InvalidInput
  else
    let rec is_not_divisor (d : int) : bool =
      d * d > n || (n mod d <> 0 && is_not_divisor (d + 1))
    in n <> 1 && is_not_divisor 2

let factors (n : int) : int list =
  let rec aux (acc : int list) (d : int) : int list =
    if d = 1 then acc
    else if n mod d = 0 && is_prime d then aux (d :: acc) (d - 1)
    else aux acc (d - 1)
  in
  match (aux [] (n / 2 + 1)) with
  | [] ->
    if n = 1 then [] else [n]
  | l -> l
;;

(* List all prime divisors including duplicates *)
let factors (n : int) : int list =
  let rec aux (acc : int list) (d : int) (c : int) : int list =
    if d = 1 then acc
    else
      (* if is_prime d && c mod d = 0 
       * there is no need to test whether d is a prime each time,
       * as long as c < d, d will be a prime *)
      if c < n && c mod d = 0 then aux (d :: acc) d (c / d)
      else
        if n mod (d - 1) = 0 && is_prime (d - 1)
        then aux ((d - 1) :: acc) (d - 1) (n / (d - 1))
        else aux acc (d - 1) n
  in
  match (aux [] (n / 2 + 1) n) with
  | [] ->
    if n = 1 then [] else [n]
  | l -> l
;;

(* A more elegant but non-tail-recursive version.
 * Find its prime factors from the smallest, and the non-primitive ones 
 * will be eliminated automatically.*)
let factors (n : int) : int list =
  let rec aux (d : int) (n : int) : int list =
    if n = 1 then []
    else
      if n mod d = 0 then d :: (aux d (n / d))
      else aux (d + 1) n
  in
  aux 2 n
;;

(* A tail-recursive version of the solution above. *)
let factors (n : int) : int list =
  let rec aux (acc : int list) (d : int) (i : int) : int list =
    if i = 1 then acc
    else
      if i mod d = 0 then aux (d :: acc) d (i / d)
      else aux acc (d + 1) i
  in
  List.rev (aux [] 2 n)
;;
