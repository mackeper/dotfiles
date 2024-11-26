from graphviz import Digraph


def parse_indented_tree(text):
    """
    Parses an indented tree from a text string where indentation represents hierarchy.
    Returns a dictionary of node IDs and their relationships.
    """
    lines = text.splitlines()
    stack = []  # Stack to track parent nodes
    nodes = {}  # Dictionary to store node IDs and their relationships
    node_id_counter = 1  # Counter for unique node IDs

    for line in lines:
        stripped_line = line.strip()
        if not stripped_line:
            continue  # Skip empty lines

        if stripped_line.startswith("<empty>"):
            stripped_line = ""

        # Determine the indentation level
        indent_level = len(line) - len(stripped_line)

        # Generate a new node ID and store the node
        current_id = str(node_id_counter)
        nodes[current_id] = (stripped_line, [])
        node_id_counter += 1

        # Establish parent-child relationship
        while stack and stack[-1][1] >= indent_level:
            stack.pop()  # Pop nodes from the stack until we find the right parent

        if stack:
            parent_id = stack[-1][0]
            nodes[parent_id][1].append(current_id)

        # Add the current node to the stack with its indentation level
        stack.append((current_id, indent_level))

    return nodes


def draw_tree_from_text(text):
    """
    Generates a highly polished tree diagram from an indented text description.
    """
    dot = Digraph(
        comment="Polished Tree from Indented Text",
        node_attr={
            "shape": "box",
            "style": "rounded,filled",
            "fontname": "Helvetica",
            "fontsize": "12",
            "margin": "0.2",
            "fillcolor": "#c3dfe9",
        },
        edge_attr={
            "arrowhead": "normal",
            "color": "#101010",
            "penwidth": "1.0",
        },
        graph_attr={
            "rankdir": "TB",
            "splines": "true",
        },
    )

    # Parse the tree structure from the indented text
    nodes = parse_indented_tree(text)

    # Add nodes and edges to the graph
    for node_id, (label, children) in nodes.items():
        # Determine the node's level based on its ID (works because IDs are added sequentially)
        dot.node(node_id, label)  # Add the node with its label and color
        for child_id in children:
            dot.edge(node_id, child_id)  # Add edges to children

    # Render the tree
    dot.render("polished_tree_output", format="png", cleanup=True)
    print("Tree rendered and saved as 'polished_tree_output.png'.")


if __name__ == "__main__":
    indented_text = """
stmtList
    stmt
        "if"
        expr
            Ident(x)
        "then"
        stmt
            "{"
            stmtList
                stmtList
                    <empty>
                    stmt
                        Ident(y)
                        "="
                        expr
                            expr
                                Num(1)
                            "-"
                            expr
                                expr
                                    Num(2)
                                "/"
                                expr
                                    Ident(z)
                        ";"
                stmt
                    Ident(z)
                    "="
                    expr
                        Ident(y)
                    ";"
            "}"
    """
    draw_tree_from_text(indented_text)
