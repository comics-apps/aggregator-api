Sequel.migration do
  change do
    create_table :issues do
      column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true
      column :cdb_id, :integer
      column :cdb_series_id, :integer
      column :cdb_publisher_id, :integer
      column :cv_id, :integer
      column :cv_series_id, :integer
      column :cv_publisher_id, :integer
      column :gcd_id, :integer
      column :gcd_series_id, :integer
      column :gcd_publisher_id, :integer
      column :m_id, :integer
      column :m_series_id, :integer
    end
  end
end
