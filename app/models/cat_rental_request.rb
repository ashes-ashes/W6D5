# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :bigint           not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CatRentalRequest < ApplicationRecord
  STATUSES = ['PENDING', 'APPROVED', 'DENIED']

  validates :start_date, :end_date, :status, presence: true
  validates :status, inclusion: {in: STATUSES}


  belongs_to :cat,
    foreign_key: :cat_id,
    class_name: 'Cat'

  def overlapping_requests
    cat = self.cat
    startproblem = cat.rental_requests.where(start_date: (self.start_date..self.end_date))
    finishproblem = cat.rental_requests.where(end_date: (self.start_date..self.end_date))
    startproblem.or(finishproblem).where.not(id: self.id)
  end
  
end
