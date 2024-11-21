type bool_expr =
  | Var of string
  | Not of bool_expr
  | And of bool_expr * bool_expr
  | Or of bool_expr * bool_expr;;

(* Evaluate the expression with a given mapping of variable values *)
let rec evaluate var_map exp =
  match exp with
  | Var(v) -> List.assoc v var_map
  | Not(exp1) -> not (evaluate var_map exp1)
  | And(exp1, exp2) -> (evaluate var_map exp1) && (evaluate var_map exp2)
  | Or(exp1, exp2) -> (evaluate var_map exp1) || (evaluate var_map exp2)

(* Generate truth table using nested loops *)
let table vars exp =
  let n = List.length vars in
  let truth_table = ref [] in
  for i = 0 to (1 lsl n) - 1 do
    (* Generate the truth value mapping for this iteration *)
    let var_map =
      List.mapi (fun j var -> (var, (i lsr j) land 1 = 1)) vars
    in
    (* Evaluate the expression with this mapping *)
    let result = evaluate var_map exp in
    (* Add the result to the truth table *)
    truth_table := (var_map, result) :: !truth_table
  done;
  List.rev !truth_table  (* Reverse to maintain correct order *)
;;

(* Helper function to print the truth table *)
let bool_to_string b = if b then "True" else "False";;

let print_table table =
  List.iter (fun (var_map, result) ->
    let vars_str =
      String.concat ", " (List.map (fun (var, value) -> var ^ "=" ^ (bool_to_string value)) var_map)
    in
    Printf.printf "[%s] -> %s\n" vars_str (bool_to_string result)
  ) table;;
