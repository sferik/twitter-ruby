require 'sqlite3'

module Twitter
  class SqliteIdentityMap
    include SQLite3

    def initialize
      @database = Database.new(":memory:")
    end

    # @param klass
    # @param key
    # @return [Object]
    def fetch(klass, key)
      table = table_from_class(klass)
      create_table(table)
      statement = @database.prepare("SELECT object FROM #{table} WHERE key = :key")
      row = statement.execute!(:key => key).first
      Marshal.load(row.first) unless row.nil?
    end

    # @param key
    # @param object
    # @return [Object]
    def store(key, object)
      table = table_from_class(object.class)
      create_table(table)
      statement = @database.prepare("INSERT INTO #{table}(key, object) VALUES (:key, :object)")
      statement.execute(:key => key, :object => Blob.new(Marshal.dump(object)))
      object
    end

  private

    # @params klass [Class]
    # @return [String]
    def table_from_class(klass)
      klass.to_s.downcase.gsub("::", "__")
    end

    # @param table [Class]
    def create_table(table)
      @database.execute("CREATE TABLE IF NOT EXISTS #{table}(key VARCHAR NOT NULl, object BLOB)")
      @database.execute("CREATE UNIQUE INDEX IF NOT EXISTS #{table}_unique_key ON #{table}(key)")
    end

  end
end
