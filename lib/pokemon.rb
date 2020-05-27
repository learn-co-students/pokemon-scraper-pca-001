class Pokemon
  attr_reader :id, :db
  attr_accessor :name, :type
  def initialize(id = nil, name = nil, type = nil, db = nil)
    @name = name
    @type = type
    @id = id
    @db = db
  end

  class << self
    def save(name, type, db)
      sql = <<-SQL
        INSERT INTO pokemon(name, type)
        VALUES (?, ?)
      SQL
      db.execute(sql, name, type)
      @id = db.execute(
        "SELECT last_insert_rowid() FROM pokemon"
    )[0][0]
    end

    def find(id, db)
      sql = "SELECT * FROM pokemon WHERE id = ?"
      row = db.execute(sql, id.to_s)[0]
      Pokemon.new(row[0], row[1], row[2])
    end
  end
end
