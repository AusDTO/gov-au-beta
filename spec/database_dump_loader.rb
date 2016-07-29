
# Loads a Postgres database dump.
#
# Only COPY blocks are extracted. Any other commands, comments, whitespace is ignored.
#
# Skips content_blocks (because it's still in prod, and schema_migrations
# (because db:test:prepare will already have popuated it and you'll get unique
# key violations).
#
class DatabaseDumpLoader
  # *dump* is the entire content of a database dump as a string.
  # This is fine while the dump is small. An enumerable would be better.
  def initialize(dump)
    @lines = dump.lines
    @conn = ActiveRecord::Base.connection.raw_connection
  end

  def load
    load_dump
  end

  private

  def load_dump
    while @lines.count > 0
      line = @lines.shift
      if line =~ /^COPY/
        if line !~ /content_blocks/ && line !~ /schema_migrations/
          copy_table(line)
        else
          skip_table
        end
      end
    end
  end

  def skip_table
    while @lines[0] !~ /^\\\./
      @lines.shift
    end
  end

  def copy_table(copy_cmd)
    @conn.copy_data(copy_cmd) do
      data_line = @lines.shift
      while data_line !~ /^\\\./
        @conn.put_copy_data(data_line)
        data_line = @lines.shift
      end
    end
  end
end
