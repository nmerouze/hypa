class Hypa::Action
  include Virtus
  attribute :name, Symbol
  attribute :method, String
  attribute :_parameters, Array, writer: :private, default: [] # FIX: accessor: :private doesn't work
  attribute :responses, Hash[Integer => Hypa::Response]

  def initialize(attributes = {}, &block)
    super(attributes)
    (block.arity == 1 ? yield(self) : instance_eval(&block)) if block_given?
  end

  def params(*params)
    params.empty? ? self._parameters : self._parameters = params
  end

  def response(status, template)
    self.responses[status] = Hypa::Response.new(status: 200, template: template)
  end

  def to_hash
    { name: self.name, method: self.method, params: self.params, responses: responses.map { |s,r| r.to_hash } }
  end
end