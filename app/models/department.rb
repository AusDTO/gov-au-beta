class Department < Section
  resourcify

  has_and_belongs_to_many :agencies,
        class_name: 'Section',
        join_table: :section_connections,
        foreign_key: :section_id,
        association_foreign_key: :connection_id


end
