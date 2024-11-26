type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr


let rec evaluat var_vals exp =
  match exp with
  | Var(v) -> List.assoc v var_vals 
  | And(exp1, exp2) -> (evaluat var_vals exp1) && (evaluat var_vals exp2)
  | Or(exp1, exp2) -> (evaluat var_vals exp1) || (evaluat var_vals exp2)
  | Not(exp1) -> not (evaluat var_vals exp1)


let rec all_combinations vars =
  match vars with
  | [] -> [[]] 
  | v::vs ->
      let rest = all_combinations vs in
      (List.map (fun comb -> (v, true)::comb) rest) @
      (List.map (fun comb -> (v, false)::comb) rest)


let table vars exp =
  let combinations = all_combinations vars in
  List.map (fun var_vals -> (var_vals, evaluat var_vals exp)) combinations
