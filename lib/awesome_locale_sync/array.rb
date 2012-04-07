class Array
  def detect_diff(arr1, arr2)
    copy = self.clone
    copy.each_with_index.collect do |value, index|
      if value.is_a? Array
        copy[index].detect_diff(arr1[index], arr2[index])
      else
        if arr1[index].nil? or arr1[index] == arr2[index]
          value
        else
          AwesomeLocaleSync::AwesomeLocaleSync.tag_updated(value.to_s, arr2[index])
        end
      end
    end
  end

  def prune_leafs(value, append)
    copy = self.clone
    copy.map do |el|
      if el.is_a? Array
        el.prune_leafs(value, append)
      elsif el.is_a? Symbol
        el
      elsif el.is_a? Integer
        el
      elsif el.is_a? TrueClass or el.is_a? FalseClass
        el
      else
        if append
          el.to_s + value
        else
          value
        end
      end
    end
  end
end