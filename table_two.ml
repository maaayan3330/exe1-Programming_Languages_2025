type bool_expr =
| Var of string 
| Not of bool_expr
| And of bool_expr * bool_expr
| Or of bool_expr * bool_expr;;


let rec evaluat a b exp =
match exp with
| Var(v) -> if v = "a" then a else b
| And(exp1 , exp2) -> (evaluat a b exp1) && (evaluat a b exp2)
| Or(exp1 , exp2) -> (evaluat a b exp1) || (evaluat a b exp2)
| Not (exp1) -> not (evaluat a b exp1)


let table_two a b exp =
[(true,true,evaluat true true exp);
(true,false,evaluat true false exp);
(false,true,evaluat false true exp);
(false,false,evaluat false false exp)]



