module ViewHelper
  def self.format_rupiah(amount)
    "Rp " + amount.to_i.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
  end
end
