class Hash
  def prune_leafs(leaf_value = nil, append = false)
    copy = self.clone
    copy.each do |key, value|
      if value.is_a? Hash
        copy[key] = value.prune_leafs(leaf_value, append)
      elsif value.is_a? Array
        copy[key] = value.prune_leafs(leaf_value, append)
      elsif not value.is_a? Symbol
        if append
          copy[key] = copy[key].to_s + leaf_value
        else
          copy[key] = leaf_value
        end
      end
    end
    copy
  end

  def detect_diff(base_hash, default_hash)
    copy = self.clone
    copy.each do |key, value|
      if value.is_a? Hash
        copy[key] = (base_hash[key] ? value.detect_diff(base_hash[key], default_hash[key]) : copy[key])
      elsif value.is_a? Array
        copy[key] = copy[key].detect_diff(base_hash[key], default_hash[key])
      else
        unless base_hash[key] == default_hash[key] or base_hash[key].nil?
          copy[key] = AwesomeLocaleSync::AwesomeLocaleSync.tag_updated(copy[key], default_hash[key])
        end
      end
    end
    copy
  end

  def deep_subtract(hash, keep_missing = false)
    copy = self.clone
    copy.each do |key, value|
      if value.is_a? Hash and hash.is_a? Hash
        copy[key] = value.deep_subtract(hash[key], keep_missing)
      else
        if hash.is_a? Hash and not hash[key].nil?
          copy[key] = hash[key]
        else
          copy.delete(key) unless keep_missing
        end
      end
    end
    copy.delete_if { |key, value| value.is_a? Hash and value.empty? }
    copy
  end

  def deep_stringify_keys!
    replace_hash = Hash.new
    self.each_pair do |k,v|
      if (k.kind_of? Symbol)
        v.deep_stringify_keys! if v.kind_of? Hash and v.respond_to? :deep_stringify_keys!
        replace_hash[k.to_s.encode(Encoding::UTF_8)] = delete(k)
      else
        v.deep_stringify_keys! if v.kind_of? Hash and v.respond_to? :deep_stringify_keys!
        replace_hash[k] = v
      end
    end
    self.replace(replace_hash)
  end

  def deep_stringify_keys
    copy = self.deep_dup
    copy.deep_stringify_keys!
    copy
  end

  def deep_dup
    duplicate = self.dup
    duplicate.each_pair do |k,v|
      tv = duplicate[k]
      duplicate[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_dup : v
    end
    duplicate
  end
end