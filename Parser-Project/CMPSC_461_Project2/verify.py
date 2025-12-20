import Parser as p
import checker as test_cases


def run_test(test_name, test_input, expected_output):
    """
    This function runs the lexer and parser on the test input,
    compares the parsed AST with the expected output, and returns the result.
    """
    print(f"--- Running {test_name} ---")
    try:
        # Initialize the lexer and tokenize the input
        lexer = p.Lexer(test_input)
        tokens = lexer.tokenize()

        # Initialize the parser and generate the AST
        parser = p.Parser(tokens)
        ast = parser.parse()

        # Convert the AST to string format using to_string() for comparison
        result = ""
        for node in ast:
            result += node.to_string()

        # Remove all spaces and newlines for a clean comparison
        result_clean = result.replace(" ", "").replace("\n", "")
        expected_output_clean = expected_output.replace(" ", "").replace("\n", "")

        # Compare the result with the expected output
        if result_clean == expected_output_clean and parser.messages == []:
            print(f"{test_name} passed.")
            return 1
        else:
            if parser.messages != []:
                print(f"{test_name} failed with wrong error messages:")
                for msg in parser.messages:
                    print(msg)
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


def run_fail_test(test_name, test_input, expected_error_msg):
    """
    This function runs the lexer and parser on the test input,
    expects it to fail, and checks if the error message matches the expected one.
    """
    print(f"--- Running {test_name} ---")
    try:
        # Initialize the lexer and tokenize the input
        lexer = p.Lexer(test_input)
        tokens = lexer.tokenize()

        # Initialize the parser and generate the AST
        parser = p.Parser(tokens)
        _ = parser.parse()
        error_message = ""
        for msg in parser.messages:
            error_message += msg
        if expected_error_msg.strip() == error_message.strip():
            print(f"{test_name} passed.")
            return 1
        else:
            print(f"{test_name} failed.")
            print("\nExpected error message:")
            print(expected_error_msg.strip())
            print("\nGot error messages:")
            print(error_message.strip())
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
    }

    test_fail_data = {
        "Test Case 5": (test_cases.test_input_5, test_cases.expected_error_msg_5),
        "Test Case 6": (test_cases.test_input_6, test_cases.expected_error_msg_6),
        "Test Case 7": (test_cases.test_input_7, test_cases.expected_error_msg_7),
        "Test Case 8": (test_cases.test_input_8, test_cases.expected_error_msg_8),
        "Test Case 9": (test_cases.test_input_9, test_cases.expected_error_msg_9),
        "Test Case 10": (test_cases.test_input_10, test_cases.expected_error_msg_10),
    }

    for name, (test_input, expected_output) in test_data.items():
        total_tests += 1
        passed_tests += run_test(name, test_input, expected_output)

    for name, (test_input, expected_error_msg) in test_fail_data.items():
        total_tests += 1
        passed_tests += run_fail_test(name, test_input, expected_error_msg)

    print(f"\n--- Summary ---")
    print(f"Passed {passed_tests} out of {total_tests} tests.")


if __name__ == "__main__":
    main()
