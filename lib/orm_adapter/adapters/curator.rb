require 'curator'

module Curator
  module Model
    module ClassMethods
      include OrmAdapter::ToAdapter
    end

    class OrmAdapter < ::OrmAdapter::Base
      def repository
        @repository ||= "#{klass.name}Repository".constantize
      end

      # get a list of column names for a given class
      def column_names
        klass.attributes
      end

      # @see OrmAdapter::Base#get!
      def get!(id)
        repository.find_by_id(wrap_key(id)) or raise "not found"
      end

      # @see OrmAdapter::Base#get
      def get(id)
        repository.find_by_id(wrap_key(id))
      end

      # @see OrmAdapter::Base#find_first
      def find_first(options = {})
        raise NotSupportedError
        #conditions, order = extract_conditions!(options)
        #klass.limit(1).where(conditions_to_fields(conditions)).order_by(order).first
      end

      # @see OrmAdapter::Base#find_all
      def find_all(options = {})
        raise NotSupportedError
        #conditions, order, limit, offset = extract_conditions!(options)
        #klass.where(conditions_to_fields(conditions)).order_by(order).limit(limit).offset(offset)
      end

      # @see OrmAdapter::Base#create!
      def create!(attributes = {})
        object = klass.new attributes
        repository.save(object)
      end

      # @see OrmAdapter::Base#destroy
      def destroy(object)
        repository.delete(object.id) if valid_object?(object)
      end

    protected

      # converts and documents to ids
      def conditions_to_fields(conditions)
      end
    end
  end
end
