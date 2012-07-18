require 'sqlite3'

module Twitter
  class SqliteIdentityMap
    include SQLite3

    def initialize
      @database = Database.new(":memory:")
    end

    # @param id
    # @return [Object]
    def fetch(id)
      create_table
      @select ||= @database.prepare("SELECT object FROM identity_map WHERE id = :id")
      row = @select.execute!(:id => id).first
      Marshal.load(row.first) unless row.nil?
    end

    # @param id
    # @param object
    # @return [Object]
    def store(id, object)
      create_table
      @insert ||= @database.prepare("INSERT INTO identity_map(id, object) VALUES (:id, :object)")
      @insert.execute(:id => id, :object => Blob.new(Marshal.dump(object)))
      object
    rescue SQLite3::ConstraintException
      @delete ||= @database.prepare("DELETE FROM identity_map WHERE id = :id")
      @delete.execute(:id => id)
      retry
    end

  private

    def create_table
      @database.execute("CREATE TABLE IF NOT EXISTS identity_map(id VARCHAR NOT NULl, object BLOB)")
      @database.execute("CREATE UNIQUE INDEX IF NOT EXISTS index_identity_map_on_id ON identity_map(id)")
    end

  end
end
