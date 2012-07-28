require 'sqlite3'

module Twitter
  class SqliteIdentityMap
    include SQLite3

    # It should be painfully obvious that this code is purely experimental and
    # should never be used in a production environment.
    GC.disable

    def initialize
      @database = Database.new(":memory:")
    end

    # @param id
    # @return [Object]
    def fetch(id)
      create_table
      @select ||= @database.prepare("SELECT object_id FROM identity_map WHERE id = :id")
      row = @select.execute!(:id => id).first
      ObjectSpace._id2ref(row.first) unless row.nil?
    end

    # @param id
    # @param object
    # @return [Object]
    def store(id, object)
      create_table
      @insert ||= @database.prepare("INSERT INTO identity_map(id, object_id) VALUES (:id, :object_id)")
      @insert.execute(:id => id, :object_id => object.object_id)
      object
    rescue SQLite3::ConstraintException
      @delete ||= @database.prepare("DELETE FROM identity_map WHERE id = :id")
      @delete.execute(:id => id)
      retry
    end

  private

    def create_table
      @database.execute("CREATE TABLE IF NOT EXISTS identity_map(id VARCHAR NOT NULL, object_id INTEGER)")
      @database.execute("CREATE UNIQUE INDEX IF NOT EXISTS index_identity_map_on_id ON identity_map(id)")
    end

  end
end
