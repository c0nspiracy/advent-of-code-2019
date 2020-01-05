class MinPriorityQueue
  Node = Struct.new :element,
                    :key,
                    :rank,
                    :parent,
                    :left_child,
                    :right_sibling

  def initialize
    @top = nil
    @roots = []
    @references = {}
  end

  def push(element, key)
    node = Node.new(element, key, 0)

    @top = @top ? select(@top, node) : node
    @roots << node
    @references[element] = node

    element
  end

  def pop
    return unless @top

    element = @top.element
    @references.delete element
    @roots.delete @top

    child = @top.left_child

    while child
      next_child = child.right_sibling
      child.parent = nil
      child.right_sibling = nil
      @roots << child
      child = next_child
    end

    @roots = coalesce @roots
    @top = @roots.inject { |top, node| select(top, node) }

    element
  end

  def empty?
    @references.empty?
  end

  private

  def select(parent_node, child_node)
    parent_node.key <= child_node.key ? parent_node : child_node
  end

  def coalesce(trees)
    coalesced_trees = []

    while tree = trees.pop
      if coalesced_tree = coalesced_trees[tree.rank]
        coalesced_trees[tree.rank] = nil
        trees << add(tree, coalesced_tree)
      else
        coalesced_trees[tree.rank] = tree
      end
    end

    coalesced_trees.compact
  end

  def add(node_one, node_two)
    adder_node, addend_node =
      if node_one.key <= node_two.key
        [node_one, node_two]
      else
        [node_two, node_one]
      end

    addend_node.parent = adder_node

    addend_node.right_sibling = adder_node.left_child
    adder_node.left_child = addend_node
    adder_node.rank += 1
    adder_node
  end
end
