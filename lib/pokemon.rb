class Pokemon
  attr_accessor :name, :type, :db
  attr_reader :id

  def initialize(name:, type:, db:, id: nil)
    @id = id
    @name = name
    @type = type
    @db = db
  end

  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?)
    SQL
    db.execute(sql, name, type)
    @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    type = row[2]
    new(id, name, type)
  end

  def self.find(id, db)
    pk_char = db.execute("SELECT * FROM pokemon WHERE id = ?", id).flatten

    Pokemon.new(id: pk_char[0], name: pk_char[1], type: pk_char[2], db: db)
  end
end
