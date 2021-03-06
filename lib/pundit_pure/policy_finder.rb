module PunditPure
  # Finds policy and scope classes for given object.
  # @api public
  # @example
  #   user = User.find(params[:id])
  #   finder = PolicyFinder.new(user)
  #   finder.policy #=> UserPolicy
  #   finder.scope #=> UserPolicy::Scope
  #
  class PolicyFinder
    attr_reader :object

    # @param object [any] the object to find policy and scope classes for
    #
    def initialize(object)
      @object = object
    end

    # @return [nil, Scope{#resolve}] scope class which can resolve to a scope
    # @see https://github.com/elabs/pundit_pure#scopes
    # @example
    #   scope = finder.scope #=> UserPolicy::Scope
    #   scope.resolve #=> <#ActiveRecord::Relation ...>
    #
    def scope
      policy::Scope if policy
    rescue NameError
      nil
    end

    # @return [nil, Class] policy class with query methods
    # @see https://github.com/elabs/pundit_pure#policies
    # @example
    #   policy = finder.policy #=> UserPolicy
    #   policy.show? #=> true
    #   policy.update? #=> false
    #
    def policy
      klass = find
      klass = Object.const_get(klass) if klass.is_a?(String)
      klass
    rescue NameError
      nil
    end

    # @return [Scope{#resolve}] scope class which can resolve to a scope
    # @raise [NotDefinedError] if scope could not be determined
    #
    def scope!
      raise NotDefinedError, "unable to find policy scope of nil" if object.nil?
      scope or raise NotDefinedError, "unable to find scope `#{find}::Scope` for `#{object.inspect}`"
    end

    # @return [Class] policy class with query methods
    # @raise [NotDefinedError] if policy could not be determined
    #
    def policy!
      raise NotDefinedError, "unable to find policy of nil" if object.nil?
      policy or raise NotDefinedError, "unable to find policy `#{find}` for `#{object.inspect}`"
    end

  private

    def find
      if object.nil?
        nil
      elsif object.respond_to?(:policy_class)
        object.policy_class
      elsif object.class.respond_to?(:policy_class)
        object.class.policy_class
      else
        klass = if object.is_a?(Array)
          object.map { |x| find_class_name(x) }.join("::")
        else
          find_class_name(object)
        end
        "#{klass}#{SUFFIX}"
      end
    end

    def find_class_name(subject)
      if subject.is_a?(Class)
        subject
      elsif subject.is_a?(Symbol)
        camelize(subject)
      else
        subject.class
      end
    end

    # copied from ActiveSupport
    def camelize(term)
      term.to_s.split("_").each(&:capitalize!).join("")
    end
  end
end
