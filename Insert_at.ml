(*PART - 1: Ocaml*)
(*insert function - get index, char ans list : put the char in the index of the list*)

let insert_at n indexn list =
    let rec aux i = function
        | [] -> []
        | h :: t -> if i = indexn than h = n else h :: aux(i + 1) t
        | 