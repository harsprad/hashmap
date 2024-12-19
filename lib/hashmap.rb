require_relative './linked-list-location'
require_relative LINKED_LIST_LOCATION

class HashMap
  def inititialize(capacity=16, load_factor=0.75)
    @capacity = capacity
    @load_factor = load_factor

    @entries = Array.new(capacity) {LinkedList.new}
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char do |char| 
      hash_code += prime_number ** (key.index(char)) * char.ord
    end

    hash_code
  end

  def set(key, value)
    index = hash(key) % @capacity
    key_node = has?(key)

    if key_node
      key_node.value = [key, value]
    else
      @entries[index].append([key, value]) 
    end

    grow() if buckets() > @capacity * @load_factor
  end

  def has?(key)
    index = hash(key)
    node = @entries[index]
    until node == nil do
      return node if node.value[0] == key
      node = node.next_node
    end
    false
  end

  def buckets
    @entries.drop_while{ |e| e == LinkedList.new }.size
  end

  def grow
    old_entries = @entries.clone
    @capacity *= 2
    @entries = Array.new(capacity) {LinkedList.new}

    # rehash
    old_entries.each |list| do
      node = list.head
      until node == nil do
        set(node.value)
        node = node.next_node
      end
    end
  end

  def get(key)
    node = @entries[hash(key) % @capacity].head
    until node == nil do
      return node.value[1] if node.value[0] == key
      node = node.next_node
    end
    nil
  end

  def remove(key)
  end

  def length
  end

  def clear
  end

  def keys
  end
  
  def values
  end

  def entries
  end
end
