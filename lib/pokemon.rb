class Pokemon

  attr_reader :id
  attr_accessor :name, :type, :db

  def initialize(id: nil, name: nil, type: nil, db: nil)
    @id = id
    @name = name
    @type = type
    @db = db
  end

  def self.create(name:, type:, db:)
    pkmn = new(name: name, type: type, db: db)
    pkmn.save
    pkmn
  end

  def save
    if id
      update
    else
      sql = <<-SQL
        INSERT INTO pokemon(name, type)
        VALUES (?,?)
      SQL
      @db.execute(sql, @name, @type)
      @id = @db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end

  end

  def self.save(name, type, db)
    create(name: name, type: type, db: db)
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

  def self.find(id, db)
    sql = <<-SQL
      SELECT id, name, type
      FROM pokemon
      WHERE id = ?
    SQL

    db.execute(sql, id).map { |row| new_from_db(row) }.first
  end

  def self.new_from_db(row)
    new(id: row[0], name: row[1], type: row[2])
  end
end
