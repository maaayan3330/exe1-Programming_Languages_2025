#!/bin/bash

# Remove old build artifacts and results
rm -rf results 2> /dev/null || true
mkdir results

# Set OCaml source file
OCAML_FILE="comparator_tree.ml"

# Check if the OCaml file exists
if [ ! -f "$OCAML_FILE" ]; then
    echo "Error: OCaml file '$OCAML_FILE' not found!"
    exit 1
fi

# Test case definitions (OCaml code snippets)
TEST_CASES=(
    # Test Case 1: Integer values
    "let tree = Empty;;
     let comp x y = x < y;;
     let tree = comparator_tree tree 5 comp;;
     let tree = comparator_tree tree 3 comp;;
     let tree = comparator_tree tree 7 comp;;
     let tree = comparator_tree tree 6 comp;;
     let rec string_of_tree = function
       | Empty -> \"\"
       | Node(data, l, r) ->
           match l, r with
           | Empty, Empty -> string_of_int data
           | _, _ -> (string_of_int data) ^ \"(\" ^ (string_of_tree l) ^ \",\" ^ (string_of_tree r) ^ \")\";;
     print_endline (string_of_tree tree);;"

    # Test Case 2: String values
    "let tree = Empty;;
     let comp x y = String.compare x y < 0;;
     let tree = comparator_tree tree \"mango\" comp;;
     let tree = comparator_tree tree \"apple\" comp;;
     let tree = comparator_tree tree \"banana\" comp;;
     let tree = comparator_tree tree \"pear\" comp;;
     let rec string_of_tree = function
       | Empty -> \"\"
       | Node(data, l, r) ->
           match l, r with
           | Empty, Empty -> data
           | _, _ -> data ^ \"(\" ^ (string_of_tree l) ^ \",\" ^ (string_of_tree r) ^ \")\";;
     print_endline (string_of_tree tree);;"

    # Test Case 3: Edge case - Single node
    "let tree = Empty;;
     let comp x y = x < y;;
     let tree = comparator_tree tree 42 comp;;
     let rec string_of_tree = function
       | Empty -> \"\"
       | Node(data, l, r) ->
           match l, r with
           | Empty, Empty -> string_of_int data
           | _, _ -> (string_of_int data) ^ \"(\" ^ (string_of_tree l) ^ \",\" ^ (string_of_tree r) ^ \")\";;
     print_endline (string_of_tree tree);;"

    # Test Case 4: Edge case - Empty tree
    "let tree = Empty;;
     let rec string_of_tree = function
       | Empty -> \"Empty\"
       | Node(data, l, r) ->
           match l, r with
           | Empty, Empty -> string_of_int data
           | _, _ -> (string_of_int data) ^ \"(\" ^ (string_of_tree l) ^ \",\" ^ (string_of_tree r) ^ \")\";;
     print_endline (string_of_tree tree);;"
)

# Expected outputs for each test case
EXPECTED_OUTPUTS=(
    "5(3,7(6,))"
    "mango(apple(,banana),pear)"
    "42"
    "Empty"
)

# Compile and run test cases
for i in "${!TEST_CASES[@]}"; do
    TEST_CODE="${TEST_CASES[$i]}"
    EXPECTED_OUTPUT="${EXPECTED_OUTPUTS[$i]}"
    OUTPUT_FILE="results/test_$i.txt"
    EXPECTED_FILE="results/expected_$i.txt"

    echo "Running test case $i..."

    # Create a temporary OCaml file for this test case
    TEST_FILE="temp.ml"
    echo "(* Generated test case *)" > $TEST_FILE
    cat $OCAML_FILE >> $TEST_FILE
    echo "$TEST_CODE" >> $TEST_FILE

    # Compile the OCaml file
    ocamlc -o test_binary_tree $TEST_FILE 2> results/compile_errors.txt
    if [ $? -ne 0 ]; then
        echo "Compilation failed for test case $i. See results/compile_errors.txt for details."
        exit 1
    fi

    # Run the compiled binary and capture output
    ./test_binary_tree > $OUTPUT_FILE 2> results/runtime_errors.txt
    if [ $? -ne 0 ]; then
        echo "Runtime error for test case $i. See results/runtime_errors.txt for details."
        exit 1
    fi

    # Save expected output to a file
    echo "$EXPECTED_OUTPUT" > $EXPECTED_FILE

    # Compare output with expected output
    diff -y --suppress-common-lines $EXPECTED_FILE $OUTPUT_FILE > results/diff_$i.txt
    if [ $? -ne 0 ]; then
        echo "Test case $i failed. See results/diff_$i.txt for differences."
    else
        echo "Test case $i passed."
    fi

    # Clean up
    rm -f test_binary_tree $TEST_FILE test_binary_tree.cmi test_binary_tree.cmo
done

echo "All tests completed."
