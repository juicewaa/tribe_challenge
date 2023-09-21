class BundlesController < ApplicationController
  def index; end

  def breakdown
    args = {
      img: params[:img].to_i,
      flac: params[:flac].to_i,
      vid: params[:vid].to_i,
    }.delete_if { |_, v| v.blank? }

    @result = ComputeBundleService.new(**args).call
  end
end
