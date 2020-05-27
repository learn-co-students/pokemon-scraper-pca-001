class Pokemon
  attr_accessor :id, :name, :type, :db

  def initialize(name:, type:, db:, id: nil)
    @name = name
    @type = type
    @id = id
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
    self.new(id, name, type)
  end

  def self.find(id_number, db)
    pokemon_character = db.execute("SELECT * FROM pokemon WHERE id = ?", id_number).flatten
    Pokemon.new(id: pokemon_character[0], name: pokemon_character[1], type: pokemon_character[2], db: db)
  end

end
