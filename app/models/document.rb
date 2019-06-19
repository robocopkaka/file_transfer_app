class Document < ApplicationRecord
  has_one_attached :file

  validates_presence_of :name
end
