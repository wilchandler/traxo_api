module Traxo
  class BaseModel

    def initialize(args, attributes)
      attributes.each do |attribute|
        i_var = "@#{attribute}".to_sym
        value = args[attribute.to_s]
        self.instance_variable_set(i_var, value)
      end
    end

  end
end