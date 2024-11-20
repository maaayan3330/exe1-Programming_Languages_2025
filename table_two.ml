type bool_expr =
| Var of string 
| Not of bool_expr
| And of bool_expr * bool_expr
| Or of bool_expr * bool_expr;;


let rec evaluat s1 s2 val1 val2 exp =
match exp with
| Var(v) -> if v = s1  then val1 else val2
| And(exp1 , exp2) -> (evaluat s1 s2 val1 val2 exp1) && (evaluat s1 s2 val1 val2 exp2)
| Or(exp1 , exp2) -> (evaluat s1 s2 val1 val2 exp1) || (evaluat s1 s2 val1 val2 exp2)
| Not (exp1) -> not (evaluat s1 s2 val1 val2 exp1)

let table_two s1 s2 exp =
[(true,true,evaluat s1 s2 true true exp);
(true,false,evaluat s1 s2 true false exp);
(false,true,evaluat s1 s2 false true exp);
(false,false,evaluat s1 s2 false false exp)]