type 'a binary_tree =
    |Empty 
    |Node of 'a * 'a binary_tree * 'a binary_tree;;


let rec comparator_tree t arg comp_func =
    match t with
    | Empty -> Node (arg,Empty,Empty)
    | Node(key,l,r) -> if comp_func arg key = true then Node(key, l , comparator_tree r arg comp_func) else Node(key, comparator_tree l arg comp_func, r)