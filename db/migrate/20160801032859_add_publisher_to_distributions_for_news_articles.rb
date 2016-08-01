class AddPublisherToDistributionsForNewsArticles < ActiveRecord::Migration[5.0]

  class Node < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Section < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class NewsDistributions < ActiveRecord::Base
    belongs_to :news_article
    belongs_to :distribution, polymorphic: true
  end

  class NewsArticle < Node
    belongs_to :section
    has_many :news_distributions
    has_many :sections, through: :news_distributions, source: :distribution,
             source_type: 'Section'
  end

  def up
    NewsArticle.all.each do |node|
      unless node.sections.include? node.section
        node.sections.append node.section if node.section.present?
        node.save!
      end
    end
  end

  def down
  end
end
