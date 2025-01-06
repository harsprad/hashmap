require_relative 'linked_list_location'
require_relative LINKED_LIST_LOCATION

class HashMap
  attr_accessor :entries

  def initialize(capacity = 16, load_factor = 0.75)
    @initial_capacity = capacity
    @capacity = capacity
    @load_factor = load_factor

    @entries = Array.new(capacity) { LinkedList.new }
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char do |char|
      hash_code += (prime_number**key.index(char)) * char.ord
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

    grow if buckets > @capacity * @load_factor
  end

  def has?(key)
    index = hash(key) % @capacity
    node = @entries[index].head
    until node.nil?
      return node if node.value[0] == key

      node = node.next_node
    end
    false
  end

  def buckets
    @entries.count { |e| !e.head.nil? }
  end

  def grow
    old_entries = @entries.clone
    @capacity *= 2
    @entries = Array.new(@capacity) { LinkedList.new }

    # rehash
    old_entries.each do |list|
      node = list.head
      until node.nil?
        set(*node.value)
        node = node.next_node
      end
    end
  end

  def get(key)
    node = @entries[hash(key) % @capacity].head
    until node.nil?
      return node.value[1] if node.value[0] == key

      node = node.next_node
    end
    nil
  end

  def remove(key)
    entry = @entries[hash(key) % @capacity]
    node = entry.head
    link_number = 0
    until node.nil?
      if node.value[0] == key
        entry.remove_at(link_number)
        return node.value[1]
      end
      node = node.next_node
      link_number += 1
    end
    nil
  end

  def length
    length = 0
    @entries.each do |list|
      node = list.head
      until node.nil?
        length += 1
        node = node.next_node
      end
    end
    length
  end

  def clear
    @capacity = @initial_capacity
    @entries = Array.new(@capacity) { LinkedList.new }
  end

  def keys
    keys = []
    @entries.each do |list|
      node = list.head
      until node.nil?
        keys.append(node.value[0])
        node = node.next_node
      end
    end
    keys
  end

  def values
    values = []
    @entries.each do |list|
      node = list.head
      until node.nil?
        values.append(node.value[1])
        node = node.next_node
      end
    end
    values
  end

  def put_entries
    entries = []
    @entries.each do |list|
      node = list.head
      until node.nil?
        entries.append(node.value)
        node = node.next_node
      end
    end
    entries
  end
end
