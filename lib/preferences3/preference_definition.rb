module Preferences3
  # Represents the definition of a preference for a particular model
  class PreferenceDefinition
    # The data type for the content stored in this preference type
    attr_reader :type

    def initialize(name, *args) #:nodoc:
      options = args.extract_options!
      options.assert_valid_keys(:default, :group_defaults)

      @type = args.first ? args.first.to_sym : :boolean

      # Create a column that will be responsible for typecasting
      sql_type = @type == :any ? nil : @type.to_s
      @column = ActiveRecord::ConnectionAdapters::Column.new(
        name.to_s,
        options[:default],
        column_cast_type(sql_type).new,
        sql_type
      )

      @group_defaults = (options[:group_defaults] || {}).inject({}) do |defaults, (group, default)|
        defaults[group.is_a?(Symbol) ? group.to_s : group] = type_cast(default)
        defaults
      end
    end

    # The name of the preference
    def name
      @column.name
    end

    # The default value to use for the preference in case none have been
    # previously defined
    def default_value(group = nil)
      @group_defaults.include?(group) ? @group_defaults[group] : @column.default
    end

    # Determines whether column backing this preference stores numberic values
    def number?
      @column.number?
    end

    # Typecasts the value based on the type of preference that was defined.
    # This uses ActiveRecord's typecast functionality so the same rules for
    # typecasting a model's columns apply here.
    def type_cast(value)
      @type == :any ? value : @column.type_cast_from_database(value)
    end

    # Typecasts the value to true/false depending on the type of preference
    def query(value)
      if !(value = type_cast(value))
        false
      elsif number?
        !value.zero?
      else
        !value.blank?
      end
    end

    private

    def column_cast_type(sql_type)
      case sql_type
      when :string then ActiveRecord::Type::String
      when :integer then ActiveRecord::Type::Integer
      when :boolean then ActiveRecord::Type::Boolean
      else ActiveRecord::Type::String
      end
    end
  end
end
