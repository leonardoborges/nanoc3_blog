class Array
  def to_hash_keys(&block)
    Hash[*self.collect { |v|
      [v, block.call(v)]
    }.flatten]
  end

  def to_hash_values(&block)
    Hash[*self.collect { |v|
      [block.call(v), v]
    }.flatten]
  end
end

# Removes hidden articles from atom feed
module Nanoc3::Helpers::Blogging
  def articles
    @items.select { |item| item[:kind] == 'article' && !item[:is_hidden] }
  end
end