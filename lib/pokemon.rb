class Pokemon
  attr_accessor :name, :type, :db
  attr_reader :id

  def initialize(id: nil, name:, type:, db: nil)
    @id = id
    @name = name
    @type = type
    @db = db
  end

  def save
    if id
      update
    else
      sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?)
      SQL
      @db.execute(sql, @name, @type)
      @id = @db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end
  end

  def update
    sql = <<-SQL
      UPDATE pokemon
      SET name = ?
      SET type = ?
      WHERE id = ?
    SQL
    @db.execute(sql, @name, @type, @id)
  end

  def self.create(name:, type:, db:)
    pokemon = new(name: name, type: type, db: db)
    pokemon.save
    pokemon
  end

  def self.save(name, type, db)
    create(name: name, type: type, db: db)
  end

  def self.new_from_db(row)
    Pokemon.new(id: row[0], name: row[1], type: row[2])
  end

  def self.find(id, db)
    sql = <<-SQL
      SELECT id, name, type
      FROM pokemon
      WHERE id = ?
    SQL
    db.execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end
end
