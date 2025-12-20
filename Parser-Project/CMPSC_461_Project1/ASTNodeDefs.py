# Base class for all AST nodes
class ASTNode:
    def to_string(self):
        """Method to provide compact string representation without newlines."""
        return repr(self)

# Class for variable assignment: x = expression
class Assignment(ASTNode):
    def __init__(self, identifier, expression):
        self.identifier = identifier
        self.expression = expression

    def to_string(self):
        expr_str = self.expression.to_string() if isinstance(self.expression, ASTNode) else repr(self.expression)
        return f"Assignment({self.identifier}, {expr_str})"

# Class for binary operations: term1 + term2
class BinaryOperation(ASTNode):
    def __init__(self, left, operator, right):
        self.left = left
        self.operator = operator
        self.right = right

    def to_string(self):
        left_str = self.left.to_string() if isinstance(self.left, ASTNode) else repr(self.left)
        right_str = self.right.to_string() if isinstance(self.right, ASTNode) else repr(self.right)
        return f"BinaryOperation({left_str}, {self.operator}, {right_str})"

# Class for logical operations: a and b
class LogicalOperation(ASTNode):
    def __init__(self, left, operator, right):
        self.left = left
        self.operator = operator
        self.right = right

    def to_string(self):
        left_str = self.left.to_string() if isinstance(self.left, ASTNode) else repr(self.left)
        right_str = self.right.to_string() if isinstance(self.right, ASTNode) else repr(self.right)
        return f"LogicalOperation({left_str}, {self.operator}, {right_str})"

# Class for unary operations: -x or not y
class UnaryOperation(ASTNode):
    def __init__(self, operator, operand):
        self.operator = operator
        self.operand = operand

    def to_string(self):
        operand_str = self.operand.to_string() if isinstance(self.operand, ASTNode) else repr(self.operand)
        return f"UnaryOperation({self.operator}, {operand_str})"

# Class for print statements: print(arg1, arg2)
class PrintStatement(ASTNode):
    def __init__(self, arguments):
        self.arguments = arguments

    def to_string(self):
        args_str = ", ".join(arg.to_string() if isinstance(arg, ASTNode) else repr(arg) for arg in self.arguments)
        return f"PrintStatement([{args_str}])"

# Class for if statements
class IfStatement(ASTNode):
    def __init__(self, condition, then_block, else_block=None):
        self.condition = condition
        self.then_block = then_block
        self.else_block = else_block

    def to_string(self):
        condition_str = self.condition.to_string()
        then_str = self.then_block.to_string()
        else_str = self.else_block.to_string() if self.else_block is not None else "None"
        return f"IfStatement({condition_str}, {then_str}, {else_str})"

# Class for for statements
class ForStatement(ASTNode):
    def __init__(self, iterator, start_expr, end_expr, block):
        self.iterator = iterator
        self.start_expr = start_expr
        self.end_expr = end_expr
        self.block = block

    def to_string(self):
        start_str = self.start_expr.to_string() if isinstance(self.start_expr, ASTNode) else repr(self.start_expr)
        end_str = self.end_expr.to_string() if isinstance(self.end_expr, ASTNode) else repr(self.end_expr)
        block_str = self.block.to_string()
        return f"ForStatement({self.iterator}, {start_str}, {end_str}, {block_str})"

# Class for blocks of statements
class Block(ASTNode):
    def __init__(self, statements):
        self.statements = statements

    def to_string(self):
        statement_strs = ", ".join(stmt.to_string() for stmt in self.statements)
        return f"Block([{statement_strs}])"

