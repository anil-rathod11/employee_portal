class History < ApplicationRecord
  belongs_to :employee
  paginates_per 10
end
