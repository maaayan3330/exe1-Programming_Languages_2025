(*PART - 1: Ocaml*)
(*insert function - get index, char ans list : put the char in the index of the list*)

let insert_at n indexn list =
if indexn == 0 then n :: list
else 
    let rec aux i = function
        | [] -> []
        | h :: t -> if i = indexn then h::n::t else h :: aux(i + 1) t
    in
    aux 1 list;; 