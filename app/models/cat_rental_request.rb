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
  validate :does_not_overlap_approved_request


  belongs_to :cat,
    foreign_key: :cat_id,
    class_name: 'Cat'

  def overlapping_requests
    cat = self.cat
    startproblem = cat.rental_requests.where(start_date: (self.start_date..self.end_date))
    finishproblem = cat.rental_requests.where(end_date: (self.start_date..self.end_date))
    startproblem.or(finishproblem).where.not(id: self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def does_not_overlap_approved_request
    !(overlapping_approved_requests.exists?)
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "PENDING")
  end

  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save
      overlapping_pending_requests.each do |req|
        req.status = "DENIED"
      end
      overlapping_pending_requests.save
    end
  end

  def deny!
    self.status = "DENIED"
    self.save
  end
  
end
