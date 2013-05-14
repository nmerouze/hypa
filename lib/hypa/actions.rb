module Hypa::Actions
  include Virtus
  attribute :actions, Array[Hypa::Action]

  def get(name, &block)
    action(name, 'GET', &block)
  end

  def post(name, &block)
    action(name, 'POST', &block)
  end

  def patch(name, &block)
    action(name, 'PATCH', &block)
  end

  def delete(name, &block)
    action(name, 'DELETE', &block)
  end

  private

  def action(name, method, &block)
    self.actions << Hypa::Action.new(name: name, method: method, &block)
  end
end