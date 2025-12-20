# Test Case 1: Simple if-else
test_input_1 = """
int x
x = 10
int y
if x > 5:
  y = 1
else:
  y = 0
endif
"""
expected_output_1 = """
Declaration(('TYPE', 'int'), ('IDENTIFIER', 'x'))
Assignment(('IDENTIFIER', 'x'), ('NUMBER', 10))
Declaration(('TYPE', 'int'), ('IDENTIFIER', 'y'))
IfStatement(BinaryOperation(('IDENTIFIER', 'x'), ('GREATER', '>'), ('NUMBER', 5)), Block([Assignment(('IDENTIFIER', 'y'), ('NUMBER', 1))]), Block([Assignment(('IDENTIFIER', 'y'), ('NUMBER', 0))]))
"""

# Test Case 2: For loop with an if statement
test_input_2 = """
int i
for i = 1 to 10:
  if i % 2 == 0:
    print(i)
  endif
endfor
"""
expected_output_2 = """
Declaration(('TYPE', 'int'), ('IDENTIFIER', 'i'))
ForStatement(('IDENTIFIER', 'i'), ('NUMBER', 1), ('NUMBER', 10), Block([IfStatement(BinaryOperation(BinaryOperation(('IDENTIFIER', 'i'), ('MODULO', '%'), ('NUMBER', 2)), ('EQ', '=='), ('NUMBER', 0)), Block([PrintStatement([('IDENTIFIER', 'i')])]), None)]))
"""

# Test Case 3: Logical AND operator
test_input_3 = """
int a
hex b
a = 5
b = 0xa
bool c
if a > 0 and b < 0x10:
  c = False
endif
"""
expected_output_3 = """
Declaration(('TYPE', 'int'), ('IDENTIFIER', 'a'))
Declaration(('TYPE', 'hex'), ('IDENTIFIER', 'b'))
Assignment(('IDENTIFIER', 'a'), ('NUMBER', 5))
Assignment(('IDENTIFIER', 'b'), ('HEXNUMBER', '0xa'))
Declaration(('TYPE', 'bool'), ('IDENTIFIER', 'c'))
IfStatement(LogicalOperation(BinaryOperation(('IDENTIFIER', 'a'), ('GREATER', '>'), ('NUMBER', 0)), ('AND', 'and'), BinaryOperation(('IDENTIFIER', 'b'), ('LESS', '<'), ('HEXNUMBER', '0x10'))), Block([Assignment(('IDENTIFIER', 'c'), ('BOOL', 'False'))]), None)
"""

# Test Case 4: Nested if-else statements
test_input_4 = """
int x
hex y
bool z
x = 10
if x > 5:
  if x < 15:
    y = 0x1
  else:
    y = 0x2
  endif
else:
  y = 0x3
endif
z = True
"""
expected_output_4 = """
Declaration(('TYPE', 'int'), ('IDENTIFIER', 'x'))
Declaration(('TYPE', 'hex'), ('IDENTIFIER', 'y'))
Declaration(('TYPE', 'bool'), ('IDENTIFIER', 'z'))
Assignment(('IDENTIFIER', 'x'), ('NUMBER', 10))
IfStatement(BinaryOperation(('IDENTIFIER', 'x'), ('GREATER', '>'), ('NUMBER', 5)), Block([IfStatement(BinaryOperation(('IDENTIFIER', 'x'), ('LESS', '<'), ('NUMBER', 15)), Block([Assignment(('IDENTIFIER', 'y'), ('HEXNUMBER', '0x1'))]), Block([Assignment(('IDENTIFIER', 'y'), ('HEXNUMBER', '0x2'))]))]), Block([Assignment(('IDENTIFIER', 'y'), ('HEXNUMBER', '0x3'))]))
Assignment(('IDENTIFIER', 'z'), ('BOOL', 'True'))
"""

# Test Case 5: Type mismatch
test_input_5 = """
int x
x = 0x10
hex y
y = 20
x = x + y
int z
z = y * 0x10
"""
expected_error_msg_5 = """
Type mismatch detected in assignment to variable x of type int with expression of type hex
Type mismatch detected in assignment to variable y of type hex with expression of type int
Type mismatch detected between int and hex
Type mismatch detected in assignment to variable z of type int with expression of type hex
"""

# Test Case 6: Type mismatch
test_input_6 = """
int x
hex y
bool b
if b or x:
  x = x * 2
endif
if y == 1:
  y = y + 0x10
endif
x = -b
"""
expected_error_msg_6 = """
Non-boolean expression used in boolean operation or if condition
Type mismatch detected between hex and int
Invalid input types in arithmetic operation
"""

# Test Case 7: Variable Declaration Before Use
test_input_7 = """
hex x
hex y
hex z
if True:
  hex w
  z = x + w
endif
w = x + y
"""
expected_error_msg_7 = """
Variable w has not been declared in the current or any enclosing scopes
"""

# Test Case 8: Variable Declaration Before Use
test_input_8 = """
bool a
bool b
if a:
  if b:
    bool c
    c = True
  endif
  if c:
    b = False
  endif
endif
"""
expected_error_msg_8 = """
Variable c has not been declared in the current or any enclosing scopes
"""

# Test Case 9: Redeclaration of variable
test_input_9 = """
bool a
bool a
bool b
if a:
  bool b
  bool c
endif
bool c
"""
expected_error_msg_9 = """
Variable a has already been declared in the current scope
"""

# Test Case 10: Scoping related errors
test_input_10 = """
if 1 < 2:
  int a
  a = 10
  if 3 > 4:
    int b
    a = a + b
  endif
  b = 5
endif
a = 15
"""
expected_error_msg_10 = """
Variable b has not been declared in the current or any enclosing scopes
Variable a has not been declared in the current or any enclosing scopes
"""
