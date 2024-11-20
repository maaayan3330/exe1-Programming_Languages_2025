let insert_at n indexn list =
if indexn == 0 then n :: list
else 
    let rec aux i = function
        | [] -> []
        | h :: t -> if i = indexn then h::n::t else h :: aux(i + 1) t
    in
    aux 1 list;; 

let insert_none_at index list =
  insert_at "None" index list;;