class AddUniqueIndexToShortUrl < ActiveRecord::Migration[7.0]
  def change
    # Remove existing index if it is not unique
    if index_exists?(:urls, :short_url) && !index_exists?(:urls, :short_url, unique: true)
      remove_index :urls, :short_url
    end

    # Add the unique index
    add_index :urls, :short_url, unique: true
  end
end
