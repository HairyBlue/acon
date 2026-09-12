#!/usr/bin/env python3
# ==============================================================================
# ACON Python Fallback Config & Query Reader: config-reader.py
# Description: Standalone config parser and JSON query evaluator providing a
#              pure Python fallback for platforms where yq and jq are missing
#              (e.g., Windows Git Bash, minimal containers).
# ==============================================================================

import argparse
import json
import os
import sys
from typing import Any, Dict, List, Optional, Tuple, Union

# Sentinel for jq 'empty' expression
EMPTY = object()


def is_truthy(val: Any) -> bool:
    """In jq, false and null (None) are falsey. Everything else is truthy."""
    return val is not None and val is not False and val is not EMPTY


class Token:
    def __init__(self, type_: str, val: Any, pos: int):
        self.type = type_
        self.val = val
        self.pos = pos

    def __repr__(self) -> str:
        return f"{self.type}({self.val})"


def tokenize(s: str) -> List[Token]:
    tokens = []
    i = 0
    n = len(s)
    while i < n:
        if s[i].isspace():
            i += 1
            continue

        # Multi-char operators
        if s[i:i + 2] in ("//", "==", "!=", "[]", "{}"):
            tokens.append(Token("OP", s[i:i + 2], i))
            i += 2
            continue

        # Single-char punctuation & operators
        if s[i] in "|()[]{},:.":
            tokens.append(Token(s[i], s[i], i))
            i += 1
            continue

        # Quoted strings
        if s[i] == '"':
            j = i + 1
            while j < n and s[j] != '"':
                if s[j] == "\\":
                    j += 1
                j += 1
            if j >= n:
                raise ValueError(f"Unterminated string in query starting at position {i}")
            str_val = json.loads(s[i:j + 1])
            tokens.append(Token("STRING", str_val, i))
            i = j + 1
            continue

        # Integers and floats
        if s[i].isdigit():
            j = i
            while j < n and s[j].isdigit():
                j += 1
            if j < n and s[j] == "." and (j + 1 < n and s[j + 1].isdigit()):
                j += 1
                while j < n and s[j].isdigit():
                    j += 1
                tokens.append(Token("FLOAT", float(s[i:j]), i))
            else:
                tokens.append(Token("INT", int(s[i:j]), i))
            i = j
            continue

        # Variables like $m, $tid
        if s[i] == "$":
            j = i + 1
            while j < n and (s[j].isalnum() or s[j] == "_"):
                j += 1
            tokens.append(Token("VAR", s[i + 1:j], i))
            i = j
            continue

        # Identifiers & keywords
        if s[i].isalpha() or s[i] == "_":
            j = i
            while j < n and (s[j].isalnum() or s[j] in ("_", "-")):
                j += 1
            tokens.append(Token("IDENT", s[i:j], i))
            i = j
            continue

        raise ValueError(f"Unexpected character '{s[i]}' at position {i}")
    return tokens


class Parser:
    def __init__(self, tokens: List[Token]):
        self.tokens = tokens
        self.pos = 0

    def peek(self) -> Optional[Token]:
        if self.pos < len(self.tokens):
            return self.tokens[self.pos]
        return None

    def match(self, type_: str, val: Any = None) -> Optional[Token]:
        tok = self.peek()
        if not tok or tok.type != type_:
            return None
        if val is not None and tok.val != val:
            return None
        self.pos += 1
        return tok

    def expect(self, type_: str, val: Any = None) -> Token:
        tok = self.match(type_, val)
        if not tok:
            curr = self.peek()
            exp_str = f"{type_}:{val}" if val is not None else type_
            curr_str = f"{curr.type}:{curr.val}" if curr else "EOF"
            raise ValueError(f"Expected {exp_str}, got {curr_str}")
        return tok

    def parse(self) -> Tuple[Any, ...]:
        node = self.parse_expr()
        if self.pos < len(self.tokens):
            remaining = self.tokens[self.pos:]
            raise ValueError(f"Unexpected trailing tokens: {remaining}")
        return node

    def parse_expr(self) -> Tuple[Any, ...]:
        tok = self.peek()
        if tok and tok.type == "IDENT" and tok.val == "if":
            return self.parse_if()
        return self.parse_alt()

    def parse_if(self) -> Tuple[Any, ...]:
        self.expect("IDENT", "if")
        cond = self.parse_expr()
        self.expect("IDENT", "then")
        then_branch = self.parse_expr()
        elifs = []
        while self.match("IDENT", "elif"):
            el_cond = self.parse_expr()
            self.expect("IDENT", "then")
            el_then = self.parse_expr()
            elifs.append((el_cond, el_then))
        self.expect("IDENT", "else")
        else_branch = self.parse_expr()
        self.expect("IDENT", "end")
        return ("if", cond, then_branch, elifs, else_branch)

    def parse_alt(self) -> Tuple[Any, ...]:
        left = self.parse_pipe()
        while self.match("OP", "//"):
            right = self.parse_pipe()
            left = ("//", left, right)
        return left

    def parse_pipe(self) -> Tuple[Any, ...]:
        left = self.parse_cmp()
        while self.match("|"):
            right = self.parse_cmp()
            left = ("|", left, right)
        return left

    def parse_cmp(self) -> Tuple[Any, ...]:
        left = self.parse_postfix()
        while True:
            op = self.match("OP", "==") or self.match("OP", "!=")
            if op:
                right = self.parse_postfix()
                left = (op.val, left, right)
            else:
                break
        return left

    def parse_postfix(self) -> Tuple[Any, ...]:
        node = self.parse_primary()
        while True:
            if self.match("."):
                tok = self.peek()
                if tok and tok.type in ("IDENT", "STRING"):
                    self.pos += 1
                    node = ("field", node, tok.val)
                elif self.match("["):
                    idx_node = self.parse_expr()
                    self.expect("]")
                    node = ("index", node, idx_node)
                else:
                    # Identity dot
                    pass
            elif self.match("["):
                idx_node = self.parse_expr()
                self.expect("]")
                node = ("index", node, idx_node)
            else:
                break
        return node

    def parse_primary(self) -> Tuple[Any, ...]:
        tok = self.peek()
        if not tok:
            raise ValueError("Unexpected end of query expression")

        if self.match("."):
            next_tok = self.peek()
            if next_tok and next_tok.type in ("IDENT", "STRING"):
                self.pos += 1
                return ("field", ("root",), next_tok.val)
            elif self.match("["):
                idx_node = self.parse_expr()
                self.expect("]")
                return ("index", ("root",), idx_node)
            return ("root",)

        if self.match("("):
            node = self.parse_expr()
            self.expect(")")
            return node

        if tok.type in ("STRING", "INT", "FLOAT"):
            self.pos += 1
            return ("literal", tok.val)

        if tok.type == "VAR":
            self.pos += 1
            return ("var", tok.val)

        if tok.type == "OP":
            if tok.val == "[]":
                self.pos += 1
                return ("literal", [])
            if tok.val == "{}":
                self.pos += 1
                return ("literal", {})

        if tok.type == "IDENT":
            self.pos += 1
            name = tok.val
            if name == "true":
                return ("literal", True)
            if name == "false":
                return ("literal", False)
            if name == "null":
                return ("literal", None)
            if name == "empty":
                return ("empty",)
            if name == "length":
                return ("func", "length")
            if name == "type":
                return ("func", "type")
            if name == "ascii_downcase":
                return ("func", "ascii_downcase")
            if name in ("map", "index"):
                self.expect("(")
                arg = self.parse_expr()
                self.expect(")")
                return ("call", name, arg)
            # Default bare identifier treated as field access on root
            return ("field", ("root",), name)

        raise ValueError(f"Unexpected token in query: {tok}")


def eval_node(node: Tuple[Any, ...], ctx: Any, vars_dict: Dict[str, Any]) -> Any:
    op = node[0]
    if op == "root":
        return ctx

    if op == "literal":
        return node[1]

    if op == "var":
        return vars_dict.get(node[1])

    if op == "empty":
        return EMPTY

    if op == "field":
        base = eval_node(node[1], ctx, vars_dict)
        if isinstance(base, dict):
            return base.get(node[2])
        return None

    if op == "index":
        base = eval_node(node[1], ctx, vars_dict)
        idx = eval_node(node[2], ctx, vars_dict)
        if isinstance(base, list):
            if isinstance(idx, str) and idx.isdigit():
                idx = int(idx)
            if isinstance(idx, int) and 0 <= idx < len(base):
                return base[idx]
        elif isinstance(base, dict) and isinstance(idx, str):
            return base.get(idx)
        return None

    if op == "func":
        fname = node[1]
        if fname == "length":
            if ctx is None:
                return 0
            if isinstance(ctx, (list, dict, str)):
                return len(ctx)
            return 0
        if fname == "type":
            if ctx is None:
                return "null"
            if isinstance(ctx, bool):
                return "boolean"
            if isinstance(ctx, (int, float)):
                return "number"
            if isinstance(ctx, str):
                return "string"
            if isinstance(ctx, list):
                return "array"
            if isinstance(ctx, dict):
                return "object"
            return "unknown"
        if fname == "ascii_downcase":
            if isinstance(ctx, str):
                return ctx.lower()
            return ctx
        raise ValueError(f"Unsupported built-in function: {fname}")

    if op == "call":
        cname = node[1]
        arg_expr = node[2]
        if cname == "map":
            if isinstance(ctx, list):
                res = []
                for item in ctx:
                    val = eval_node(arg_expr, item, vars_dict)
                    if val is not EMPTY:
                        res.append(val)
                return res
            return None
        if cname == "index":
            target = eval_node(arg_expr, ctx, vars_dict)
            if isinstance(ctx, list):
                try:
                    return ctx.index(target)
                except ValueError:
                    return None
            return None

    if op == "//":
        left = eval_node(node[1], ctx, vars_dict)
        if is_truthy(left):
            return left
        return eval_node(node[2], ctx, vars_dict)

    if op == "|":
        left = eval_node(node[1], ctx, vars_dict)
        if left is EMPTY:
            return EMPTY
        return eval_node(node[2], left, vars_dict)

    if op == "==":
        left = eval_node(node[1], ctx, vars_dict)
        right = eval_node(node[2], ctx, vars_dict)
        return left == right

    if op == "!=":
        left = eval_node(node[1], ctx, vars_dict)
        right = eval_node(node[2], ctx, vars_dict)
        return left != right

    if op == "if":
        cond = eval_node(node[1], ctx, vars_dict)
        if is_truthy(cond):
            return eval_node(node[2], ctx, vars_dict)
        for el_cond, el_then in node[3]:
            if is_truthy(eval_node(el_cond, ctx, vars_dict)):
                return eval_node(el_then, ctx, vars_dict)
        return eval_node(node[4], ctx, vars_dict)

    raise ValueError(f"Unknown AST node operator: {op}")


def evaluate_query(data: Any, query_str: str, vars_dict: Optional[Dict[str, Any]] = None) -> Any:
    if vars_dict is None:
        vars_dict = {}
    tokens = tokenize(query_str.strip())
    parser = Parser(tokens)
    ast = parser.parse()
    return eval_node(ast, data, vars_dict)


def load_yaml(file_path: str) -> Any:
    try:
        import yaml
    except ImportError:
        sys.stderr.write(
            "ERROR: Python 'yaml' module (PyYAML) is required but not installed.\n"
            "  Install: pip install pyyaml\n"
        )
        sys.exit(1)

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
            return data if data is not None else {}
    except Exception as e:
        sys.stderr.write(f"ERROR: Failed to read YAML file '{file_path}': {e}\n")
        sys.exit(1)


def format_and_print_result(res: Any, raw: bool = False, compact: bool = False) -> None:
    if res is EMPTY:
        return
    if raw:
        if res is None:
            sys.stdout.write("null\n")
        elif isinstance(res, bool):
            sys.stdout.write("true\n" if res else "false\n")
        elif isinstance(res, (int, float)):
            sys.stdout.write(f"{res}\n")
        elif isinstance(res, str):
            sys.stdout.write(f"{res}\n")
        elif isinstance(res, (dict, list)):
            if compact:
                sys.stdout.write(json.dumps(res, separators=(",", ":")) + "\n")
            else:
                sys.stdout.write(json.dumps(res, indent=2) + "\n")
        else:
            sys.stdout.write(f"{res}\n")
    else:
        if compact:
            sys.stdout.write(json.dumps(res, separators=(",", ":")) + "\n")
        else:
            sys.stdout.write(json.dumps(res, indent=2) + "\n")


def wrap_result(raw_file_path: str, task_id: str, harness: str, model: str) -> Dict[str, Any]:
    try:
        with open(raw_file_path, "r", encoding="utf-8", errors="replace") as f:
            content = f.read()
    except Exception as e:
        sys.stderr.write(f"ERROR: Could not read raw file '{raw_file_path}': {e}\n")
        sys.exit(1)

    try:
        parsed = json.loads(content)
        if isinstance(parsed, dict):
            if "task_id" not in parsed or not parsed["task_id"]:
                parsed["task_id"] = task_id
            if "harness" not in parsed or not parsed["harness"]:
                parsed["harness"] = harness
            if "model" not in parsed or not parsed["model"]:
                parsed["model"] = model
            return parsed
        else:
            return {
                "task_id": task_id,
                "harness": harness,
                "model": model,
                "result": parsed,
            }
    except Exception:
        return {
            "task_id": task_id,
            "harness": harness,
            "model": model,
            "output": content,
        }


def main():
    parser = argparse.ArgumentParser(
        description="ACON Python Fallback Config & JSON Reader"
    )
    parser.add_argument("pos", nargs="*", help="Positional arguments: [file] or [query] [file]")
    parser.add_argument("-q", "--query", type=str, help="Dot-path or jq-like query to evaluate")
    parser.add_argument("-r", "--raw", "--raw-output", dest="raw", action="store_true", help="Output raw string without JSON quotes")
    parser.add_argument("-c", "--compact", "--compact-output", dest="compact", action="store_true", help="Compact JSON output without indentation")
    parser.add_argument("--json-eval", action="store_true", help="Treat input data as JSON rather than YAML")
    parser.add_argument("--wrap-result", action="store_true", help="Format raw adapter output into structured JSON result file")
    parser.add_argument("--raw-file", type=str, help="Path to raw output file for --wrap-result")
    parser.add_argument("--task-id", type=str, default="", help="Task ID for --wrap-result")
    parser.add_argument("--harness", type=str, default="", help="Harness name for --wrap-result")
    parser.add_argument("--model", type=str, default="", help="Model name for --wrap-result")
    parser.add_argument("--arg", nargs=2, action="append", default=[], metavar=("KEY", "VAL"), help="Bind variable $KEY = VAL")

    args = parser.parse_args()

    # Mode 1: Wrap result
    if args.wrap_result:
        if not args.raw_file:
            sys.stderr.write("ERROR: --wrap-result requires --raw-file <path>\n")
            sys.exit(1)
        res = wrap_result(args.raw_file, args.task_id, args.harness, args.model)
        sys.stdout.write(json.dumps(res, indent=2) + "\n")
        sys.exit(0)

    vars_dict = {k: v for k, v in args.arg}

    # Mode 2: JSON evaluation
    if args.json_eval:
        query_str = None
        input_source = "-"

        if args.query:
            query_str = args.query
            if len(args.pos) > 0:
                input_source = args.pos[0]
        else:
            if len(args.pos) == 0:
                query_str = "."
                input_source = "-"
            elif len(args.pos) == 1:
                arg0 = args.pos[0]
                # If arg0 looks like a query or standard jq query, or is not a file
                if arg0 in ("length", "type", "empty") or arg0.startswith(".") or "(" in arg0 or "|" in arg0 or " " in arg0 or not os.path.isfile(arg0):
                    query_str = arg0
                    input_source = "-"
                else:
                    query_str = "."
                    input_source = arg0
            else:
                query_str = args.pos[0]
                input_source = args.pos[1]

        if input_source == "-" or not input_source:
            content = sys.stdin.read()
        else:
            with open(input_source, "r", encoding="utf-8") as f:
                content = f.read()

        try:
            data = json.loads(content)
        except Exception as e:
            sys.stderr.write(f"ERROR: Invalid JSON input: {e}\n")
            sys.exit(1)

        result = evaluate_query(data, query_str, vars_dict)
        format_and_print_result(result, raw=args.raw, compact=args.compact)
        sys.exit(0)

    # Mode 3: YAML configuration file reading
    if len(args.pos) == 0:
        parser.print_help(sys.stderr)
        sys.exit(1)

    target_file = args.pos[0]
    data = load_yaml(target_file)

    query_str = args.query
    if not query_str and len(args.pos) > 1:
        query_str = args.pos[1]

    if not query_str or query_str == ".":
        # If no query flag is passed: print entire parsed YAML as JSON
        if args.compact:
            sys.stdout.write(json.dumps(data, separators=(",", ":")) + "\n")
        else:
            sys.stdout.write(json.dumps(data, indent=2) + "\n")
        sys.exit(0)

    result = evaluate_query(data, query_str, vars_dict)
    format_and_print_result(result, raw=args.raw, compact=args.compact)
    sys.exit(0)


if __name__ == "__main__":
    main()
