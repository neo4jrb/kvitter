class Tag < Neo4j::Rails::Model
  property :name, :type => String

  index :name

  has_n(:tweets).from(:tags)

  has_n(:used_by_users).from(:used_tags)

  def to_s
    name
  end
end
