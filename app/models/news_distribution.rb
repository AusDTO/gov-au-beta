class NewsDistribution < ApplicationRecord
  belongs_to :news_article
  belongs_to :distribution, polymorphic: true
end
