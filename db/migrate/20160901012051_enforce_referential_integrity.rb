class EnforceReferentialIntegrity < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :users_roles, :users
    add_foreign_key :users_roles, :roles

    add_foreign_key :section_categories, :categories
    add_foreign_key :section_categories, :sections

    add_foreign_key :section_connections, :sections, column: :connection_id
    add_foreign_key :section_connections, :sections

    # Deletes orphaned news distributions
    execute <<-SQL
      delete from news_distributions where id in (
        select nd.id from news_distributions as nd left join nodes as n on (n.id = nd.news_article_id) where n.id is null
      )
    SQL
    add_foreign_key :news_distributions, :nodes, column: :news_article_id

    add_foreign_key :nodes, :nodes, column: :parent_id

    add_foreign_key :requests, :sections
    add_foreign_key :requests, :users
    add_foreign_key :requests, :users, column: :approver_id

    # NOTE: cannot add constraint on revisable_type & revisable_id (polymorphic relationship)
    add_foreign_key :revisions, :revisions, column: :parent_id

    # Some submissions have dangling submitter_ids after users were deleted.
    # So we assign all of those submissions to a lucky user.
    execute <<-SQL
      delete from submissions where id in (
        select s.id from submissions as s left join users as u on (s.submitter_id = u.id) where u.id is null
      )
    SQL

    add_foreign_key :submissions, :revisions
    add_foreign_key :submissions, :users, column: :submitter_id
    add_foreign_key :submissions, :users, column: :reviewer_id

    # roles
    # NOTE: cannot add constraint on resource_type & resource_id (polymorphic relationship)
  end
end
