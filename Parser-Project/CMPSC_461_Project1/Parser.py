import re
from typing import List, Tuple, Any, Union
from ASTNodeDefs import *

# A type alias for clarity, representing parts of expressions
# that can be a full ASTNode or a simple token tuple (like for numbers/identifiers).
ExprType = Union[ASTNode, Tuple[str, Any]]

class Lexer:
    """
    The Lexer (also known as a tokenizer or scanner) is responsible for breaking
    the raw source code string into a stream of meaningful tokens.
    """
    def __init__(self, code: str) -> None:
        """
        Initializes the Lexer.

        Args:
            code: The source code string to be tokenized.
        """
        self.code = code
        self.tokens: List[Tuple[str, Any]] = []
        # A list of tuples where each tuple contains a token name and a regex pattern.
        # The order is important, as it determines matching priority.
        self.token_specs = [
            ('NUMBER',     r'\d+'),
            ('IDENTIFIER', r'[A-Za-z_][A-Za-z0-9_]*'),
            ('IF',         r'if'),
            ('ELSE',       r'else'),
            ('FOR',        r'for'),
            ('TO',         r'to'),
            ('PRINT',      r'print'),
            ('AND',        r'and'),
            ('OR',         r'or'),
            ('NOT',        r'not'),
            ('PLUS',       r'\+'),
            ('MINUS',      r'-'),
            ('MULTIPLY',   r'\*'),
            ('DIVIDE',     r'/'),
            ('MODULO',     r'%'),
            ('EQ',         r'=='),
            ('NEQ',        r'!='),
            ('GREATER',    r'>'),
            ('LESS',       r'<'),
            ('EQUALS',     r'='),
            ('LPAREN',     r'\('),
            ('RPAREN',     r'\)'),
            ('COMMA',      r','),
            ('COLON',      r':'),
            ('SKIP',       r'[ \t\n]+'),  # Skips whitespace and newlines
            ('MISMATCH',   r'.'),         # Catches any other character
        ]
        # A single, combined regex for efficient matching.
        self.token_regex = '|'.join(f'(?P<{name}>{regex})' for name, regex in self.token_specs)

    # TODO: Implement this function
    def tokenize(self) -> List[Tuple[str, Any]]:
        """
        Why this function is needed: This is the core of the lexer. Its purpose is to
        transform the raw text-based source code into a structured list of tokens
        that the parser can understand. The parser cannot work with a raw string;
        it needs a sequence of categorized symbols.

        What this function does: It scans the input code from left to right, matching
        the text against the regular expressions defined in `self.token_specs`.
        For each fullmatch, it creates a (token_type, value) tuple and adds it to a list.
        It should handle converting numbers to integer types and correctly identifying
        keywords vs. identifiers. It discards meaningless characters like whitespace.
        The process ends when the entire code string is consumed, at which point an
        'EOF' (End of File) token is appended to signify the end of the input.
        """
        # We want to use the concept of Lookahead
        # Thus, find longest character stream that still fits a token pattern by first going until we get a character stream that does not fit a pattern token
        # Then backtrack by one character, add that sequence of characters and token name to our list, reset the value of "current_string", and then repeat

        # Define token list/needed variables
        token_lst = []
        # Add one space at the end of source code to allow one more iteration and ability to always truncate variable current_string
        source_code_plus_space = self.code + " "
        current_string = ""
        last_character = ""
        # Loop through given source code
        for character in source_code_plus_space:
            current_string += character
            # Check if any regex expressions match current character stream (besides the catch all)
            # If match found, continue to next iteration
            if ((re.fullmatch(self.token_specs[0][1], current_string)) or (re.fullmatch(self.token_specs[1][1], current_string)) or (re.fullmatch(self.token_specs[2][1], current_string)) or (re.fullmatch(self.token_specs[3][1], current_string))
            or (re.fullmatch(self.token_specs[4][1], current_string)) or (re.fullmatch(self.token_specs[5][1], current_string)) or (re.fullmatch(self.token_specs[6][1], current_string)) or (re.fullmatch(self.token_specs[7][1], current_string))
            or (re.fullmatch(self.token_specs[8][1], current_string)) or (re.fullmatch(self.token_specs[9][1], current_string)) or (re.fullmatch(self.token_specs[10][1], current_string)) or (re.fullmatch(self.token_specs[11][1], current_string))
            or (re.fullmatch(self.token_specs[12][1], current_string)) or (re.fullmatch(self.token_specs[13][1], current_string)) or (re.fullmatch(self.token_specs[14][1], current_string)) or (re.fullmatch(self.token_specs[15][1], current_string))
            or (re.fullmatch(self.token_specs[16][1], current_string)) or (re.fullmatch(self.token_specs[17][1], current_string)) or (re.fullmatch(self.token_specs[18][1], current_string)) or (re.fullmatch(self.token_specs[19][1], current_string))
            or (re.fullmatch(self.token_specs[20][1], current_string)) or (re.fullmatch(self.token_specs[21][1], current_string)) or (re.fullmatch(self.token_specs[22][1], current_string)) or (re.fullmatch(self.token_specs[23][1], current_string))
            or (re.fullmatch(self.token_specs[24][1], current_string))):
                    continue
            # Once no regex expressions match, backtrack and find last regex that did match
            # Check if current_string only has one character: This means automatic mismatch
            if (len(current_string) != 1):
                last_character = character 
                current_string = current_string[:-1]
                # Check for keywords first before identifiers
                # Add matched regex expression and token name to list
                # Reset current_string to last character that forced character stream to not match any regex expressions
                if (re.fullmatch(self.token_specs[2][1], current_string)):
                        token_lst.append(('IF', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[3][1], current_string)):
                        token_lst.append(('ELSE', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[4][1], current_string)):
                        token_lst.append(('FOR', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[5][1], current_string)):
                        token_lst.append(('TO', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[6][1], current_string)):
                        token_lst.append(('PRINT', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[7][1], current_string)):
                        token_lst.append(('AND', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[8][1], current_string)):
                        token_lst.append(('OR', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[9][1], current_string)):
                        token_lst.append(('NOT', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[0][1], current_string)):
                        # Convert Number to integer type
                        num_int = int(current_string)
                        token_lst.append(('NUMBER', num_int))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[1][1], current_string)):
                        token_lst.append(('IDENTIFIER', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[10][1], current_string)):
                        token_lst.append(('PLUS', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[11][1], current_string)):
                        token_lst.append(('MINUS', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[12][1], current_string)):
                        token_lst.append(('MULTIPLY', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[13][1], current_string)):
                        token_lst.append(('DIVIDE', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[14][1], current_string)):
                        token_lst.append(('MODULO', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[15][1], current_string)):
                        token_lst.append(('EQ', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[16][1], current_string)):
                        token_lst.append(('NEQ', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[17][1], current_string)):
                        token_lst.append(('GREATER', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[18][1], current_string)):
                        token_lst.append(('LESS', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[19][1], current_string)):
                        token_lst.append(('EQUALS', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[20][1], current_string)):
                        token_lst.append(('LPAREN', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[21][1], current_string)):
                        token_lst.append(('RPAREN', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[22][1], current_string)):
                        token_lst.append(('COMMA', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[23][1], current_string)):
                        token_lst.append(('COLON', current_string))
                        current_string = last_character
                elif (re.fullmatch(self.token_specs[24][1], current_string)):
                        # DON'T add SKIP token.
                        # Only reset current_string to last_character
                        current_string = last_character
                # Add catch all Token here in case no regex expressions match
                elif (re.fullmatch(self.token_specs[25][1], current_string)):
                    token_lst.append(('MISMATCH', current_string))
                    current_string = last_character
            # If first character is a Mismatch, catch it here
            else: 
                token_lst.append(('MISMATCH', current_string))
                current_string = ""
        # Add EOF marker to signify entire source code consumed
        token_lst.append(('EOF', "NULL"))
        # Return final list of all tokens
        return token_lst

class Parser:
    """
    The Parser takes the list of tokens generated by the Lexer and builds an
    Abstract Syntax Tree (AST). The AST is a tree representation of the source
    code's structure that is much easier to work with for later stages like
    interpretation or compilation.
    """
    def __init__(self, tokens: List[Tuple[str, Any]]) -> None:
        """
        Initializes the Parser.

        Args:
            tokens: A list of tokens from the Lexer.
        """
        self.tokens = tokens
        self.pos = 0  # The parser's current position in the token stream

    def current_token(self) -> Tuple[str, Any]:
        """A helper function to look at the current token without consuming it."""
        return self.tokens[self.pos]

    def advance(self) -> None:
        """A helper function to consume the current token and move to the next one."""
        self.pos += 1

    def expect(self, kind: str) -> Tuple[str, Any]:
        """
        Checks if the current token matches an expected type. If so, it consumes
        the token. If not, it raises a syntax error. This is crucial for
        enforcing the language's grammar rules.
        """
        if self.current_token()[0] == kind:
            token = self.current_token()
            self.advance()
            return token
        else:
            raise SyntaxError(f"Expected {kind} but got {self.current_token()[0]} at position {self.pos}")

    def parse(self) -> List[ASTNode]:
        """
        Why this function is needed: This is the main entry point for the parsing process.
        It orchestrates the entire parsing operation by repeatedly parsing the fundamental
        unit of our language: a statement.

        What this function does: It creates an empty list to hold the statements of the
        program. It then loops as long as it has not reached the 'EOF' token. In each
        iteration, it calls `parse_statement()` to parse a single statement and appends
        the resulting AST node to the list. Finally, it returns the list of statement
        nodes, which represents the complete program.
        """
        statements = []
        while self.current_token()[0] != 'EOF':
            statements.append(self.parse_statement())
        return statements

    # TODO: Implement this function
    def parse_statement(self) -> ASTNode:
        """
        Why this function is needed: Our language is composed of different kinds of statements
        (assignments, if-statements, loops, etc.). This function acts as a dispatcher. It needs
        to figure out which kind of statement is next in the token stream and call the
        correct specific function to handle it.

        What this function does: It looks at the type of the `current_token`.
        - If it's an 'IDENTIFIER', it's likely an assignment (e.g., `x = ...`).
        - If it's an 'IF', it calls `parse_if_stmt()`.
        - If it's a 'FOR', it calls `parse_for_stmt()`.
        - If it's a 'PRINT', it calls `parse_print_stmt()`.
        This routing is the essence of a top-down recursive descent parser.
        """
        # Check current token
        if (self.current_token()[0] == 'IDENTIFIER'):
              # Consume current token
              token = self.expect('IDENTIFIER')
              # Consume equal sign or raise
              self.expect('EQUALS')
              # parse expression
              expression = self.parse_expression()
              # Return Assignment AST node
              return Assignment(token, expression)
        elif (self.current_token()[0] == 'IF'):
              return self.parse_if_stmt()
        elif (self.current_token()[0] == 'FOR'):
              return self.parse_for_stmt()
        elif (self.current_token()[0] == 'PRINT'):
              return self.parse_print_stmt()
        else:
              raise SyntaxError

    # TODO: Implement this function
    def parse_if_stmt(self) -> IfStatement:
        """
        Why this function is needed: To parse the structure of an if-else statement according
        to the grammar rules.

        What this function does: It consumes the 'IF' token, then calls `parse_boolean_expression()`
        to parse the condition. It then expects and consumes a 'COLON', calls `parse_block()`
        to handle the body of the 'then' clause. After that, it checks for an 'ELSE' token to
        handle the optional else part, which also has a colon and a block. It constructs and
        returns an `IfStatement` AST node with the condition, then-block, and optional else-block.
        """
        self.expect('IF')
        condition = self.parse_boolean_expression()
        self.expect('COLON')
        then_block = self.parse_block()
        if (self.current_token()[0] == 'ELSE'):
              self.expect('ELSE')
              self.expect('COLON')
              else_block = self.parse_block()
              return IfStatement(condition, then_block, else_block)
        return IfStatement(condition, then_block)


    # TODO: Implement this function
    def parse_for_stmt(self) -> ForStatement:
        """
        Why this function is needed: To parse the specific syntax of our for-loop.

        What this function does: It consumes tokens in the expected order for a for-loop:
        'FOR', an identifier for the loop variable, 'EQUALS', an expression for the start value,
        'TO', an expression for the end value, and a 'COLON'. Finally, it calls `parse_block()`
        for the loop's body. It bundles all this information into a `ForStatement` AST node.
        """
        self.expect('FOR')
        iterator = self.expect('IDENTIFIER')
        self.expect('EQUALS')
        start_value = self.parse_expression()
        self.expect('TO')
        end_value = self.parse_expression()
        self.expect('COLON')
        block = self.parse_block()
        return ForStatement(iterator,start_value,end_value,block)

    # TODO: Implement this function
    def parse_print_stmt(self) -> PrintStatement:
        """
        Why this function is needed: To handle the language's built-in print statement.

        What this function does: It consumes the 'PRINT' token and an opening parenthesis 'LPAREN'.
        It then calls `parse_arg_list()` to parse the comma-separated expressions inside the
        parentheses. Finally, it consumes the closing parenthesis 'RPAREN' and returns a
        `PrintStatement` AST node containing the list of arguments.
        """
        self.expect('PRINT')
        self.expect('LPAREN')
        arguments = self.parse_arg_list()
        self.expect('RPAREN')
        return PrintStatement(arguments)
    
    # TODO: Implement this function
    def parse_block(self) -> Block:
        """
        Why this function is needed: Control flow statements like 'if' and 'for' need to execute
        a sequence of other statements. A 'block' represents this sequence.

        What this function does: It creates a list to hold statements. It then repeatedly calls
        `parse_statement()` to parse all statements until it reaches a token that signals the end
        of the block (in our simplified language, 'ELSE' or the end of the file). It returns a
        `Block` AST node containing the list of parsed statements.
        """
        statement_list = []
        while ((self.current_token()[0] != 'ELSE') and (self.current_token()[0] != 'EOF')):
              statement_list.append(self.parse_statement())
        return Block(statement_list)
              

    # TODO: Implement this function
    def parse_arg_list(self) -> List[ExprType]:
        """
        Why this function is needed: To handle comma-separated lists of values, such as in the
        print statement.

        What this function does: It first parses one expression. Then, it enters a loop that
        continues as long as the current token is a 'COMMA'. Inside the loop, it consumes the
        comma and parses the next expression. It returns a list of all the parsed expression nodes.
        """
        argument_list = [self.parse_expression()]
        while (self.current_token()[0] == 'COMMA'):
              self.expect('COMMA')
              argument_list.append(self.parse_expression())
        return argument_list

    # TODO: Implement this function
    def parse_boolean_expression(self) -> ExprType:
        """
        Why this function is needed: This function handles the logical 'OR' operator. To correctly
        implement operator precedence, we need a separate function for each level of precedence.
        'OR' has the lowest precedence among logical operators.

        What this function does: It first calls `parse_boolean_term()` to get the left-hand side.
        Then, it loops as long as it sees an 'OR' token. In the loop, it creates a `LogicalOperation`
        node with the left side, the 'OR' operator, and the result of parsing the right side.
        This left-associative structure correctly handles chains like `A or B or C`.
        """
        left_hand_side = self.parse_boolean_term()
        while (self.current_token()[0] == 'OR'):
              token = self.expect('OR')
              right_hand_side = self.parse_boolean_term()
              left_hand_side = LogicalOperation(left_hand_side, token, right_hand_side)
        return left_hand_side

    # TODO: Implement this function
    def parse_boolean_term(self) -> ExprType:
        """
        Why this function is needed: This handles the 'AND' operator, which has a higher
        precedence than 'OR'.

        What this function does: Its structure is identical to `parse_boolean_expression`, but
        it deals with the 'AND' operator and calls `parse_boolean_factor()` for its operands.
        This ensures that expressions like `A and B or C` are parsed as `(A and B) or C`.
        """
        left_hand_side = self.parse_boolean_factor()
        while (self.current_token()[0] == 'AND'):
              token = self.expect('AND')
              right_hand_side = self.parse_boolean_factor()
              left_hand_side = LogicalOperation(left_hand_side, token, right_hand_side)
        return left_hand_side

    # TODO: Implement this function
    def parse_boolean_factor(self) -> ExprType:
        """
        Why this function is needed: This handles the unary 'NOT' operator, which has the
        highest logical precedence.

        What this function does: It checks for a 'NOT' token. If found, it consumes it,
        recursively calls `parse_boolean_factor()` to parse the expression being negated, and
        wraps it in a `UnaryOperation` node. If there is no 'NOT', it simply calls the next
        level of the precedence hierarchy, `parse_comparison()`.
        """
        if (self.current_token()[0] == 'NOT'):
            operator = self.expect('NOT')
            operand = self.parse_boolean_factor()
            return UnaryOperation(operator, operand)
        else:
            return self.parse_comparison()

    # TODO: Implement this function
    def parse_comparison(self) -> ExprType:
        """
        Why this function is needed: To parse comparison expressions like `a > b` or `x == 10`.

        What this function does: It first calls `parse_expression()` to get the left-hand side
        (an arithmetic expression). It then checks if the current token is a comparison
        operator ('==', '!=', '>', '<'). If so, it consumes the operator and calls
        `parse_expression()` again for the right-hand side, creating a `BinaryOperation` node.
        If not, it just returns the left-hand side node it already parsed.
        """
        left_hand_side = self.parse_expression()
        while ((self.current_token()[0] == 'EQ') or (self.current_token()[0] == 'NEQ') or (self.current_token()[0] == 'GREATER') or (self.current_token()[0] == 'LESS')):
              token = self.expect(self.current_token()[0])
              right_hand_side = self.parse_expression()
              left_hand_side = BinaryOperation(left_hand_side, token, right_hand_side)
        return left_hand_side

    # TODO: Implement this function
    def parse_expression(self) -> ExprType:
        """
        Why this function is needed: To handle the lowest precedence arithmetic operators:
        addition ('+') and subtraction ('-').

        What this function does: Following the same pattern as the boolean functions, it first
        calls `parse_term()` to get a higher-precedence operand. It then loops as long as it
        sees a 'PLUS' or 'MINUS' token, building `BinaryOperation` nodes in a left-associative way.
        """
        left = self.parse_term()
        while ((self.current_token()[0] == 'MINUS') or (self.current_token()[0] == 'PLUS')):
              token = self.expect(self.current_token()[0])
              right = self.parse_term()
              left = BinaryOperation(left, token, right)
        return left

    # TODO: Implement this function
    def parse_term(self) -> ExprType:
        """
        Why this function is needed: To handle multiplication ('*'), division ('/'), and modulo ('%'),
        which have higher precedence than addition and subtraction.

        What this function does: It calls `parse_factor()` to get its operands and loops on
        '*', '/', and '%' operators. This ensures that `a + b * c` is correctly parsed as `a + (b * c)`.
        """
        left = self.parse_factor()
        while ((self.current_token()[0] == 'MULTIPLY') or (self.current_token()[0] == 'DIVIDE') or (self.current_token()[0] == 'MODULO')):
              token = self.expect(self.current_token()[0])
              right = self.parse_factor()
              left = BinaryOperation(left, token, right)
        return left


    # TODO: Implement this function
    def parse_factor(self) -> ExprType:
        """
        Why this function is needed: To handle unary plus and minus operators (e.g., `-5`).
        These have higher precedence than multiplication.

        What this function does: It checks for a 'PLUS' or 'MINUS' token. If found, it consumes it,
        recursively calls `parse_factor()` for the operand, and returns a `UnaryOperation` node.
        If not, it calls `parse_primary()` for the highest-precedence elements.
        """
        # Check current token
        if ((self.current_token()[0] == 'PLUS') or (self.current_token()[0] == 'MINUS')): 
            token = self.expect(self.current_token()[0])
            operand = self.parse_factor()
            return UnaryOperation(token, operand)
        return self.parse_primary()
        
    # TODO: Implement this function
    def parse_primary(self) -> ExprType:
        """
        Why this function is needed: This function is at the bottom of the expression parsing
        hierarchy. It handles the most basic, highest-precedence elements of expressions. These
        are the "atoms" of an expression.

        What this function does: It checks for three cases:
        1. A 'NUMBER' token.
        2. An 'IDENTIFIER' token (a variable).
        3. An opening parenthesis 'LPAREN'. If found, it recursively calls `parse_boolean_expression()`
           to parse the entire expression inside the parentheses, and then expects a closing 'RPAREN'.
           This allows for manually overriding operator precedence (e.g., `(a + b) * c`).
        """
        
        if ((self.current_token()[0] == 'NUMBER') or (self.current_token()[0] == 'IDENTIFIER')):
              token = self.expect(self.current_token()[0])
              return token
        else:
              self.expect('LPAREN')
              token_1 = self.parse_boolean_expression()
              self.expect('RPAREN')
              return token_1
              
              
        