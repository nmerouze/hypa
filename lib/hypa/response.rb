class Hypa::Response
  include Virtus
  attribute :status, Integer
  attribute :template, Hypa::Template

  def to_hash
    { status: self.status, template: (self.template ? self.template.to_hash : nil) }
  end
end