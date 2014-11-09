module Twitter
  module Utils
    # Takes a mixed array of Integers and Twitter::User objects and returns a
    # consistent array of Twitter user IDs.
    #
    # @param users [Array]
    # @return [Array<Integer>]
    def collect_user_ids(users)
      users.map do |user|
        case user
        when Integer
          user
        when Twitter::User
          user.id
        end
      end.compact
    end

    # Returns a new array with the concatenated results of running block once for every element in enumerable.
    # If no block is given, an enumerator is returned instead.
    #
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def flat_pmap(enumerable)
      return to_enum(:flat_pmap, enumerable) unless block_given?
      pmap(enumerable, &Proc.new).flatten(1)
    end
    module_function :flat_pmap

    # Returns a new array with the results of running block once for every element in enumerable.
    # If no block is given, an enumerator is returned instead.
    #
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def pmap(enumerable)
      return to_enum(:pmap, enumerable) unless block_given?
      if enumerable.count == 1
        enumerable.collect { |object| yield(object) }
      else
        enumerable.collect { |object| Thread.new { yield(object) } }.collect(&:value)
      end
    end
    module_function :pmap

    def symbolize_keys!(object)
      if object.is_a?(Array)
        object.each_with_index do |val, index|
          object[index] = symbolize_keys!(val)
        end
      elsif object.is_a?(Hash)
        object.keys.each do |key|
          object[key.to_sym] = symbolize_keys!(object.delete(key))
        end
      end
      object
    end
    module_function :symbolize_keys!
  end
end
