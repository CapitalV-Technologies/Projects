import Parser as p0
import checker as test_cases

def run_test(test_name, test_input, expected_output):
    """
    This function runs the lexer and parser on the test input,
    compares the parsed AST with the expected output, and returns the result.
    """
    print(f"--- Running {test_name} ---")
    try:
        # Initialize the lexer and tokenize the input
        lexer = p0.Lexer(test_input)
        tokens = lexer.tokenize()

        # Initialize the parser and generate the AST
        parser = p0.Parser(tokens)
        ast = parser.parse()

        # Convert the AST to string format using to_string() for comparison
        result = ""
        for node in ast:
            result += node.to_string()

        # Remove all spaces and newlines for a clean comparison
        result_clean = result.replace(" ", "").replace("\n", "")
        expected_output_clean = expected_output.replace(" ", "").replace("\n", "")

        # Compare the result with the expected output
        if result_clean == expected_output_clean:
            print(f"{test_name} passed.")
            return 1
        else:
            print(f"{test_name} failed.")
            print("\nExpected:")
            print(expected_output.strip())
            print("\nGot:")
            print(result.strip())
            print("\n--------------------")
            return 0
    except Exception as e:
        print(f"{test_name} failed with an error: {e}")
        import traceback
        traceback.print_exc()
        print("--------------------")
        return 0

def main():
    total_tests = 0
    passed_tests = 0
    
    test_data = {
        "Test Case 1": (test_cases.test_input_1, test_cases.expected_output_1),
        "Test Case 2": (test_cases.test_input_2, test_cases.expected_output_2),
        "Test Case 3": (test_cases.test_input_3, test_cases.expected_output_3),
        "Test Case 4": (test_cases.test_input_4, test_cases.expected_output_4),
        "Test Case 5": (test_cases.test_input_5, test_cases.expected_output_5),
        "Test Case 6": (test_cases.test_input_6, test_cases.expected_output_6),
        "Test Case 7": (test_cases.test_input_7, test_cases.expected_output_7),
    }

    for name, (test_input, expected_output) in test_data.items():
        total_tests += 1
        passed_tests += run_test(name, test_input, expected_output)

    print(f"\n--- Summary ---")
    print(f"Passed {passed_tests} out of {total_tests} tests.")

if __name__ == "__main__":
    main()

