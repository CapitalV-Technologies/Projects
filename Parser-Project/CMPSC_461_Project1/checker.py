# Test Case 1: Simple if-else
test_input_1 = """
x = 10
if x > 5:
  y = 1
else:
  y = 0
"""
expected_output_1 = """
Assignment(('IDENTIFIER', 'x'), ('NUMBER', 10))
IfStatement(BinaryOperation(('IDENTIFIER', 'x'), ('GREATER', '>'), ('NUMBER', 5)), Block([Assignment(('IDENTIFIER', 'y'), ('NUMBER', 1))]), Block([Assignment(('IDENTIFIER', 'y'), ('NUMBER', 0))]))
"""

# Test Case 2: For loop with an if statement
test_input_2 = """
for i = 1 to 10:
  if i % 2 == 0:
    print(i)
"""
expected_output_2 = """
ForStatement(('IDENTIFIER', 'i'), ('NUMBER', 1), ('NUMBER', 10), Block([IfStatement(BinaryOperation(BinaryOperation(('IDENTIFIER', 'i'), ('MODULO', '%'), ('NUMBER', 2)), ('EQ', '=='), ('NUMBER', 0)), Block([PrintStatement([('IDENTIFIER', 'i')])]), None)]))
"""

# Test Case 3: Logical AND operator
test_input_3 = """
a = 5
b = 10
if a > 0 and b < 20:
  c = 1
"""
expected_output_3 = """
Assignment(('IDENTIFIER', 'a'), ('NUMBER', 5))
Assignment(('IDENTIFIER', 'b'), ('NUMBER', 10))
IfStatement(LogicalOperation(BinaryOperation(('IDENTIFIER', 'a'), ('GREATER', '>'), ('NUMBER', 0)), ('AND', 'and'), BinaryOperation(('IDENTIFIER', 'b'), ('LESS', '<'), ('NUMBER', 20))), Block([Assignment(('IDENTIFIER', 'c'), ('NUMBER', 1))]), None)
"""

# Test Case 4: Logical OR operator
test_input_4 = """
a = -5
if a < 0 or a > 100:
  print(a)
"""
expected_output_4 = """
Assignment(('IDENTIFIER', 'a'), UnaryOperation(('MINUS', '-'), ('NUMBER', 5)))
IfStatement(LogicalOperation(BinaryOperation(('IDENTIFIER', 'a'), ('LESS', '<'), ('NUMBER', 0)), ('OR', 'or'), BinaryOperation(('IDENTIFIER', 'a'), ('GREATER', '>'), ('NUMBER', 100))), Block([PrintStatement([('IDENTIFIER', 'a')])]), None)
"""

# Test Case 5: Logical NOT operator
test_input_5 = """
is_valid = 0
if not is_valid == 1:
  print(1)
"""
expected_output_5 = """
Assignment(('IDENTIFIER', 'is_valid'), ('NUMBER', 0))
IfStatement(UnaryOperation(('NOT', 'not'), BinaryOperation(('IDENTIFIER', 'is_valid'), ('EQ', '=='), ('NUMBER', 1))), Block([PrintStatement([('NUMBER', 1)])]), None)
"""

# Test Case 6: Nested if-else statements
test_input_6 = """
x = 10
if x > 5:
  if x < 15:
    y = 1
  else:
    y = 2
else:
  y = 3
"""
expected_output_6 = """
Assignment(('IDENTIFIER', 'x'), ('NUMBER', 10))
IfStatement(BinaryOperation(('IDENTIFIER', 'x'), ('GREATER', '>'), ('NUMBER', 5)), Block([IfStatement(BinaryOperation(('IDENTIFIER', 'x'), ('LESS', '<'), ('NUMBER', 15)), Block([Assignment(('IDENTIFIER', 'y'), ('NUMBER', 1))]), Block([Assignment(('IDENTIFIER', 'y'), ('NUMBER', 2))]))]), Block([Assignment(('IDENTIFIER', 'y'), ('NUMBER', 3))]))
"""

# Test Case 7: Combination of logical operators
test_input_7 = """
x = 5
y = 10
if (x > 0 and y < 20) or x == 5:
    z = x + y
"""
expected_output_7 = """
Assignment(('IDENTIFIER', 'x'), ('NUMBER', 5))
Assignment(('IDENTIFIER', 'y'), ('NUMBER', 10))
IfStatement(LogicalOperation(LogicalOperation(BinaryOperation(('IDENTIFIER', 'x'), ('GREATER', '>'), ('NUMBER', 0)), ('AND', 'and'), BinaryOperation(('IDENTIFIER', 'y'), ('LESS', '<'), ('NUMBER', 20))), ('OR', 'or'), BinaryOperation(('IDENTIFIER', 'x'), ('EQ', '=='), ('NUMBER', 5))), Block([Assignment(('IDENTIFIER', 'z'), BinaryOperation(('IDENTIFIER', 'x'), ('PLUS', '+'), ('IDENTIFIER', 'y')))]), None)
"""
