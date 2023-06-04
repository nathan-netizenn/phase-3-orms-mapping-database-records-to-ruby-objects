require "sqlite3"

class Song
  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
@@ -8,12 +9,16 @@ def initialize(name:, album:, id: nil)
    @album = album
  end

  def self.db
    @@db ||= SQLite3::Database.new("songs.db")
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS songs
    SQL

   
    db.execute(sql)
  end

  def self.create_table
@@ -25,7 +30,7 @@ def self.create_table
      )
    SQL

  
    db.execute(sql)
  end

  def save
@@ -34,19 +39,43 @@ def save
      VALUES (?, ?)
    SQL

    

    self.class.db.execute(sql, self.name, self.album)


    self.id = self.class.db.last_insert_row_id

    
    self
  end

  def self.new_from_db(row)
    self.new(id: row[0], name: row[1], album: row[2])
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM songs
    SQL

    self.db.execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM songs
      WHERE name = ?
      LIMIT 1
    SQL

    self.db.execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.create(name:, album:)
    
    song = self.new(name: name, album: album)
    song.save
  end

end