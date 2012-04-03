class Ya2YAML
  def emit(obj, level)
    case obj
      when Array
        if (obj.length == 0)
          '[]'
        else
          indent = "\n" + s_indent(level - 1)
          obj.collect {|o|
            indent + '- ' + emit(o, level + 1)
          }.join('')
        end
      when Hash
        if (obj.length == 0)
          '{}'
        else
          indent = "\n" + s_indent(level - 1)
          hash_order = @options[:hash_order]
          if (hash_order && level == 1)
            hash_keys = obj.keys.sort {|x, y|
              x_order = hash_order.index(x) ? hash_order.index(x) : Float::MAX
              y_order = hash_order.index(y) ? hash_order.index(y) : Float::MAX
              o = (x_order <=> y_order)
              (o != 0) ? o : (x.to_s <=> y.to_s)
            }
          else
            hash_keys = obj.keys.sort {|x, y| x.to_s <=> y.to_s }
          end
          hash_keys.collect {|k|
            key = emit(k, level + 1)
            if (
              is_one_plain_line?(key) ||
              key =~ /\A(#{REX_BOOL}|#{REX_FLOAT}|#{REX_INT}|#{REX_NULL})\z/x
            )
              indent + key + ': ' + emit(obj[k], level + 1)
            else
              indent + '? ' + key +
              indent + ': ' + emit(obj[k], level + 1)
            end
          }.join('')
        end
      when NilClass
        '~'
      when String
        emit_string(obj, level)
      when TrueClass, FalseClass
        obj.to_s
      when Fixnum, Bignum, Float
        obj.to_s
      when Date
        obj.to_s
      when Time
        offset = obj.gmtoff
        off_hm = sprintf(
          '%+.2d:%.2d',
          (offset / 3600.0).to_i,
          (offset % 3600.0) / 60
        )
        u_sec = (obj.usec != 0) ? sprintf(".%.6d", obj.usec) : ''
        obj.strftime("%Y-%m-%d %H:%M:%S#{u_sec} #{off_hm}")
      when Symbol
        ':' + obj.to_s
      when Range
        '!ruby/range ' + obj.to_s
      when Regexp
        '!ruby/regexp ' + obj.inspect
      else
        case
          when obj.is_a?(Struct)
            struct_members = {}
            obj.each_pair{|k, v| struct_members[k.to_s] = v }
            '!ruby/struct:' + obj.class.to_s.sub(/^(Struct::(.+)|.*)$/, '\2') + ' ' +
            emit(struct_members, level + 1)
          else
            # serialized as a generic object
            object_members = {}
            obj.instance_variables.each{|k, v|
              object_members[k.to_s.sub(/^@/, '')] = obj.instance_variable_get(k)
            }
            '!ruby/object:' + obj.class.to_s + ' ' +
            emit(object_members, level + 1)
        end
    end
  end
end